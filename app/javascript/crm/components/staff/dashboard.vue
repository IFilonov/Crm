<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
    q-page-container
      q-card
        q-card-section
          span Clients
          q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:10px;"
            v-bind:disabled="isClientsDelBtnDisabled"
            @click="onDeleteClients")
          q-btn(label="Create" color="primary" @click="onCreateClient" glossy dense)
          q-dialog(v-model="qdlg.client_new" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="onSubmitClient" @reset="onReset(client)")
                  q-input(filled label="Your Fullname *" hint="Name and surname"
                    v-model="client.fullname"
                    lazy-rules :rules="[ val => val.length > 5 || 'Please type Fullname > 5 chars']")
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
          q-dialog(v-model="qdlg.client_edit" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="onEditClient" @reset="onReset(client)")
                  q-input(filled label="Your Fullname *" hint="Name and surname"
                    v-model="client.fullname"
                    lazy-rules :rules="[ val => val.length > 5 || 'Please type Fullname > 5 chars']")
                  q-input(filled type="email" label="Your email *" hint="your@email.adr"
                    v-model="client.email"
                    :rules="[ val => validEmail ]")
                  q-input(filled type="number" mask="phone" label="Your phone *"
                    v-model="client.phone"
                    lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Phone > 5 only digits']")
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
            @click="onDeleteCompanies")
          q-btn(label="Create" color="primary" @click="qdlg.company_new = true" glossy dense)
          q-dialog(v-model="qdlg.company_new" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="onSubmitCompany" @reset="onReset(company)")
                  q-input(filled label="Company name *"
                    v-model="company.name"
                    lazy-rules :rules="[ val => val.length > 2 || 'Please type name > 2 chars']")
                  q-input(filled type="number" label="INN" hint="Company inn"
                    v-model="company.inn"
                    lazy-rules :rules="[ val => val.length > 10 || 'Please type INN > 10 only digits']")
                  q-input(filled type="number" label="Company OGRN *"
                    v-model="company.ogrn"
                    lazy-rules :rules="[ val => val && val.length > 10 || 'Please type OGRN > 10 only digits']")
                  q-select(
                    v-model="company.juristic_type_id" label="Juristic type"
                    :options="juristic_types" option-value="id" option-label="name"
                    emit-value map-options
                    transition-show="flip-up" transition-hide="flip-down")
              q-card-section
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
          q-dialog(v-model="qdlg.company_edit" persistent)
            q-card
              q-card-section(class="row items-center")
                q-form(class="q-gutter-md" @submit="onEditCompany" @reset="onReset(company)")
                  q-input(filled label="Company name *"
                    v-model="company.name"
                    lazy-rules :rules="[ val => val.length > 2 || 'Please type name > 2 chars']")
                  q-input(filled type="number" label="INN" hint="Company inn"
                    v-model="company.inn"
                    lazy-rules :rules="[ val => val && val.length > 10 || 'Please type INN > 10 only digits']")
                  q-input(filled type="number" label="Company OGRN *"
                    v-model="company.ogrn"
                    lazy-rules :rules="[ val => val && val.length > 10 || 'Please type OGRN > 10 only digits']")
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
import paths from '../../api/paths';

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
      qdlg: {
        client_edit: false,
        client_new: false,
        company_new: false,
        company_edit: false,
        prevValue: []
      }
    }
  },
  methods: {
    onCreateClient() {
      this.resetEntity(this.client);
      this.qdlg.client_new = true;
    },
    onSubmitClient(evt) {
      this.sendClient(this.client);
      this.qdlg.client_new = false;
    },
    onEditClient(evt) {
      this.editClient(this.client);
      this.rebindCompaniesToClient();
      this.qdlg.client_edit = false;
    },
    onEditCompany(evt) {
      this.editCompany(this.company);
      this.rebindCilentsToCompany();
      this.qdlg.company_edit = false;
    },
    onSubmitCompany(evt) {
      this.sendCompany(this.company);
    },
    onReset(entity) {
      this.resetEntity(entity);
    },
    resetEntity(entity) {
      for(let key in entity){
         entity[key] = '';
      }
    },
    async sendClient(client) {
      try {
        const response = await this.$api.post(paths.client_create, client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async editClient(client) {
      try {
        const response = await this.$api.patch(paths.client_update, client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async editCompany(company) {
      try {
        const response = await this.$api.patch(paths.company_update, company);
        await this.getCompanies();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async rebindCompaniesToClient() {
      try {
        const response = await this.$api.patch(paths.rebind_companies_to_client, this.getParamsClientCompanies());
      } catch(err)  {
        this.errors.push(err);
      }
    },
    getParamsClientCompanies() {
      let new_company_ids = this.arrDiffs(this.client_companies, this.qdlg.prevValue);
      let del_company_ids = this.arrDiffs(this.qdlg.prevValue, this.client_companies);
      return { client_id: this.client["id"], new_company_ids: new_company_ids, del_company_ids: del_company_ids }
    },
    async rebindCilentsToCompany() {
      try {
        const response = await this.$api.patch(paths.rebind_clients_to_company, this.getParamsCompanyClients());
      } catch(err)  {
        this.errors.push(err);
      }
    },
    getParamsCompanyClients() {
      let new_client_ids = this.arrDiffs(this.company_clients, this.qdlg.prevValue);
      let del_client_ids = this.arrDiffs(this.qdlg.prevValue, this.company_clients);
      return { company_id: this.company["id"], new_client_ids: new_client_ids, del_client_ids: del_client_ids }
    },
    async sendCompany(company) {
      try {
        const response = await this.$api.post(paths.company_create, company);
        await this.getCompanies();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getClients() {
      try {
        const response = await this.$api.get(paths.clients);
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
        const response = await this.$api.post(paths.clients_delete, clients_selected);
        this.clients_selected = [];
        await this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanies() {
      try {
        const response = await this.$api.get(paths.companies);
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getJuristicTypes() {
      try {
        const response = await this.$api.get(paths.juristic_types);
        this.juristic_types = response.data;
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
        const response = await this.$api.post(paths.companies_delete, companies_selected);
        this.companies_selected = [];
        await this.getCompanies();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.clients_selected.length === 0 ? '' :
          `${this.clients_selected.length} record${this.clients_selected.length > 1 ? 's' : ''} selected of ${this.clients.length}`
    },
    onDblClickClientsTable(evt, row, index) {
      this.client = row;
      this.getClientCompanies(this.client);
      this.qdlg.prevValue = this.client_companies;
      this.qdlg.client_edit = true;
    },
    onDblClickCompaniesTable(evt, row, index) {
      this.company = row;
      this.getCompanyClients(this.company);
      this.qdlg.company_edit = true;
    },
    async getClientCompanies(client) {
      try {
        const response = await this.$api.post(paths.client_companies, client);
        this.client_companies = response.data;
        this.qdlg.prevValue = this.client_companies;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanyClients(company) {
      try {
        const response = await this.$api.post(paths.company_clients, company);
        this.company_clients = response.data;
        this.qdlg.prevValue = this.company_clients;
      } catch(err) {
        this.errors.push(err);
      }
    },
    arrDiffs(a, b) {
      return a.filter(x => !b.includes(x));
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
