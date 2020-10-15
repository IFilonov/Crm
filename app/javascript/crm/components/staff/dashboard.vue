<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
    q-page-container
      q-card
        q-card-section
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
                    q-btn(label="Update" type="submit" color="primary")
                    q-btn(flat label="Cancel" color="primary" v-close-popup)
        q-card-section
          span Companies
          q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:10px;"
            v-bind:disabled="isCompaniesDelBtnDisabled"
            @click="deleteCompanies")
          q-btn(label="Create" color="primary" @click="qDialogs.company_new = true" glossy dense)
          q-dialog(v-model="qDialogs.company_new" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="sendCompany(company)" @reset="reset(company)")
                  q-input(filled label="Company name *"
                    v-model="company.name"
                    lazy-rules :rules="[ val => val && val.length > 2 || 'Please type name > 2 chars']")
                  q-input(filled type="number" label="INN" hint="Company inn"
                    v-model="company.inn"
                    lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type INN > 10 only digits']")
                  q-input(filled type="number" label="Company OGRN *"
                    v-model="company.ogrn"
                    lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type OGRN > 10 only digits']")
                  q-select(
                    v-model="company.juristic_type_id" label="Juristic type"
                    :options="juristic_types" option-value="id" option-label="name"
                    emit-value map-options
                    transition-show="flip-up" transition-hide="flip-down")
                  q-btn(label="Submit" type="submit" color="primary")
                  q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
                  q-btn(flat label="Cancel" color="primary" v-close-popup)
          br
          q-table(dense row-key="name" selection="multiple"
            :data="companies"
            @row-dblclick="onDblClickCompaniesTable"
            :pagination.sync="pagination"
            :selected.sync="companies_selected"
            :visible-columns=['name', 'inn', 'jur_type', 'ogrn'])
          q-dialog(v-model="qDialogs.company_edit" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="onEditCompany")
                  q-input(filled label="Company name *"
                    v-model="company.name"
                    lazy-rules :rules="[ val => val && val.length > 2 || 'Please type name > 2 chars']")
                  q-input(filled type="number" label="INN" hint="Company inn"
                    v-model="company.inn"
                    lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type INN > 10 only digits']")
                  q-input(filled type="number" label="Company OGRN *"
                    v-model="company.ogrn"
                    lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type OGRN > 10 only digits']")
                  q-select(
                    v-model="company.juristic_type_id" label="Juristic type"
                    :options="juristic_types" option-value="id" option-label="name"
                    emit-value map-options
                    transition-show="flip-up" transition-hide="flip-down")
                  p Bind with clients:
                  q-select(
                    v-model="company_clients" label="Clients"
                    multiple counter use-chips
                    :options="clients" option-value="id" option-label="fullname"
                    emit-value map-options
                    transition-show="flip-up" transition-hide="flip-down")
                  div
                    q-btn(label="Update" type="submit" color="primary")
                    q-btn(flat label="Cancel" color="primary" v-close-popup)
</template>

<script>
import ERRORS from "../../utils/errors";
import VALIDATORS from "../../utils/validators";
import functions from "../../utils/functions";

export default {
  data() {
    return {
      clients: [],
      client_companies: [],
      company_clients: [],
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
      companies_selected: [],
      company: {
        name: '',
        inn: '',
        juristic_type_id: '',
        ogrn: ''
      },
      qDialogs: {
        client_edit: false,
        client_new: false,
        company_new: false,
        company_edit: false,
        prevValue: []
      }
    }
  },
  methods: {
    onEditClient(evt) {
      this.editClient(this.client);
      this.rebindCompaniesToClient();
      this.qDialogs.client_edit = false;
    },
    onEditCompany(evt) {
      this.editCompany(this.company);
      this.rebindCilentsToCompany();
      this.qDialogs.company_edit = false;
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
    async editCompany(company) {
      try {
        const response = await this.$api.companies.update(company);
        await this.getCompanies();
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
    async rebindCilentsToCompany() {
      try {
        let new_client_ids = functions.arrDiffs(this.company_clients, this.qDialogs.prevValue);
        let del_client_ids = functions.arrDiffs(this.qDialogs.prevValue, this.company_clients);
        let clients = { company_id: this.company["id"], new_client_ids: new_client_ids, del_client_ids: del_client_ids };
        const response = await this.$api.client_companies.rebind_clients(clients);
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async sendCompany(company) {
      try {
        this.qDialogs.company_new = false;
        const response = await this.$api.companies.create(company);
        this.reset(this.company);
        await this.getCompanies();
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
    async deleteCompanies() {
      try {
        let companies_selected = { ids:  this.companies_selected.map(company => company.id ) } ;
        const response = await this.$api.companies.delete(companies_selected);
        this.companies_selected = [];
        this.getCompanies();
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
    onDblClickCompaniesTable(evt, row, index) {
      this.company = Object.assign({},row);
      this.getCompanyClients(row);
      this.qDialogs.company_edit = true;
    },
    async getClientCompanies(client) {
      try {
        const response = await this.$api.companies.client_companies(client);
        this.client_companies = response.data;
        this.qDialogs.prevValue = this.client_companies;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanyClients(company) {
      try {
        const response = await this.$api.companies.clients(company);
        this.company_clients = response.data;
        this.qDialogs.prevValue = this.company_clients;
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
    },
    isCompaniesDelBtnDisabled() {
      return this.companies_selected.length === 0;
    }
  },
  mounted() {
    this.getJuristicTypes();
    this.getClients();
    this.getCompanies();
  }
}
</script>

<style scoped>
</style>
