<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
      q-card
        q-card-section
          q-form(class="q-gutter-md" @submit="onSubmit" @reset="onReset")
            q-input(filled label="Your Fullname *" hint="Name and surname"
              v-model="client.fullname"
              lazy-rules :rules="[ val => val.length > 0 || 'Please type Fullname > 5 chars']")
            q-input(filled type="email" label="Your email *" hint="your@email.adr"
              v-model="client.email"
              :rules="[ val => validEmail ]")
            q-input(filled type="number" mask="phone" label="Your phone *"
              v-model="client.phone"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type phone > 5 only digits']")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
    q-page-container
      q-card
        q-card-section
          q-btn(label="Delete" type="Delete" color="primary" glossy dense
            v-bind:disabled="isClientsDelBtnDisabled"
            @click="onDeleteClients")
          p
          q-table(title="Clients" dense row-key="email" selection="multiple"
            :data="clients"
            :pagination.sync="pagination"
            :selected-rows-label="getSelectedString"
            :selected.sync="clients_selected"
            :visible-columns=['fullname', 'email', 'phone'])
        q-card-section
          q-btn(label="Delete" type="Delete" color="primary" glossy dense
            v-bind:disabled="isCompaniesDelBtnDisabled"
            @click="onDeleteCompanies")
          p
          q-table(title="Companies" dense row-key="name" selection="multiple"
            :data="companies"
            :pagination.sync="pagination"
            :selected.sync="companies_selected"
            :visible-columns=['name', 'inn', 'jur_type', 'ogrn'])
</template>

<script>
import ERRORS from "../../utils/errors";
import VALIDATORS from "../../utils/validators";
export default {
  data() {
    return {
      clients: [],
      companies: [],
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
      companies_selected: []
    }
  },
  props: ['staff_paths'],
  methods: {
    onSubmit(evt) {
      this.sendCurrentClient(this.client);
    },
    onReset(evt) {
      for(let key in this.client){
        this.client[key] = '';
      }
    },
    async sendCurrentClient (client) {
      try {
        const response = await this.$api.post(this.staff_paths.client_create, client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getClients() {
      try {
        const response = await this.$api.get(this.staff_paths.clients);
        this.clients = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    onDeleteClients(evt) {
      this.deleteClients();
    },
    async deleteClients() {
      try {
        let clients_selected = { ids:  this.clients_selected.map(client => client.id ) } ;
        const response = await this.$api.post(this.staff_paths.clients_delete, clients_selected);
        this.clients_selected = [];
        await this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanies() {
      try {
        const response = await this.$api.get(this.staff_paths.companies);
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    onDeleteCompanies(evt) {
      this.deleteCompanies();
    },
    async deleteCompanies() {
      try {
        let companies_selected = { ids:  this.companies_selected.map(company => company.id ) } ;
        const response = await this.$api.post(this.staff_paths.companies_delete, companies_selected);
        this.companies_selected = [];
        await this.getCompanies();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.clients_selected.length === 0 ? '' :
          `${this.clients_selected.length} record${this.clients_selected.length > 1 ? 's' : ''} selected of ${this.clients.length}`
    }
  },
  computed: {
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    },
    isClientsDelBtnDisabled() {
      return this.clients_selected.length === 0;
    },
    isCompaniesDelBtnDisabled() {
      return this.companies_selected.length === 0;
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
