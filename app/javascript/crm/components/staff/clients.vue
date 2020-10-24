<template lang="pug">
  span Clients
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:10px;"
      v-bind:disabled="isClientsDelBtnDisabled"
      @click="deleteClients")
    q-btn(label="Create" color="primary" @click="qDialogs.client_new = true" glossy dense)
    q-dialog(v-model="qDialogs.client_new" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="sendClient(client)" @reset="reset(client)")
            q-input(filled label="Your Fullname *" hint="Name and surname"
              v-model="client.fullname"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Fullname > 5 chars']")
            q-input(filled type="email" label="Your email *" hint="your@email.adr"
              v-model="client.email"
              :rules="[ val => validEmail ]")
            q-input(filled type="number" mask="phone" label="Your phone *"
              v-model="client.phone"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Phone > 5 only digits']")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
    br
    q-table(dense row-key="email" selection="multiple"
      @row-dblclick="onDblClickClientsTable"
      :data="clients"
      :pagination.sync="pagination"
      :selected-rows-label="getSelectedString"
      :selected.sync="clients_selected"
      :visible-columns=['fullname', 'email', 'phone'])
    q-dialog(v-model="qDialogs.client_edit" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="onEditClient")
            q-input(filled label="Your Fullname *" hint="Name and surname"
              v-model="client.fullname"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Fullname > 5 chars']")
            q-input(filled type="email" label="Your email *" hint="your@email.adr"
              v-model="client.email"
              :rules="[ val => validEmail ]")
            q-input(filled type="number" mask="phone" label="Your phone *"
              v-model="client.phone"
              lazy-rules :rules="[ val => val && val.toString().length > 5 || 'Please type Phone > 5 only digits']")
            q-select(
              v-model="client_companies" label="Companies"
              multiple counter use-chips
              :options="companies" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Update" type="submit" color="primary" glossy dense)
              q-btn(flat label="Cancel" color="primary" v-close-popup)
</template>

<script>
import functions from "../../utils/functions";
import VALIDATORS from "../../utils/validators";
import ERRORS from "../../utils/errors";

export default {
  data() {
    return {
      clients: [],
      client_companies: [],
      companies: [],
      juristic_types: [],
      errors: [],
      client: {
        fullname: '',
        email: '',
        phone: ''
      },
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
      clients_selected: [],
      qDialogs: {
        client_edit: false,
        client_new: false,
        prevValue: []
      },
    }
  },
  methods: {
    onEditClient(evt) {
      this.editClient(this.client);
      this.rebindCompaniesToClient();
      this.qDialogs.client_edit = false;
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendClient(client) {
      try {
        this.qDialogs.client_new = false;
        const response = await this.$api.clients.create(client);
        this.reset(this.client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async editClient(client) {
      try {
        const response = await this.$api.clients.update(client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async rebindCompaniesToClient() {
      try {
        let new_company_ids = functions.arrDiffs(this.client_companies, this.qDialogs.prevValue);
        let del_company_ids = functions.arrDiffs(this.qDialogs.prevValue, this.client_companies);
        let companies = { client_id: this.client["id"], new_company_ids: new_company_ids, del_company_ids: del_company_ids }
        const response = await this.$api.client_companies.rebind_companies(companies);
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getClients() {
      try {
        const response = await this.$api.clients.index();
        this.clients = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async deleteClients() {
      try {
        let clients_selected = { ids:  this.clients_selected.map(client => client.id ) };
        const response = await this.$api.clients.delete(clients_selected);
        this.clients_selected = [];
        this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanies() {
      try {
        const response = await this.$api.companies.index();
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getJuristicTypes() {
      try {
        const response = await this.$api.juristic_types.index();
        this.juristic_types = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.clients_selected.length === 0 ? '' :
          `${this.clients_selected.length} record${this.clients_selected.length > 1 ? 's' : ''} selected of ${this.clients.length}`
    },
    onDblClickClientsTable(evt, row, index) {
      this.client = Object.assign({},row);
      this.getClientCompanies(row);
      this.qDialogs.prevValue = this.client_companies;
      this.qDialogs.client_edit = true;
    },
    async getClientCompanies(client) {
      try {
        const response = await this.$api.companies.client_companies(client);
        this.client_companies = response.data;
        this.qDialogs.prevValue = this.client_companies;
      } catch(err) {
        this.errors.push(err);
      }
    }
  },
  computed: {
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    },
    isClientsDelBtnDisabled() {
      return this.clients_selected.length === 0;
    }
  },
  mounted() {
    this.getClients();
    this.getCompanies();
  }
}
</script>

<style scoped>
</style>
