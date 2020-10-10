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
          q-btn(label="Create" color="primary" @click="client_dialog = true" glossy dense)
          q-dialog(v-model="client_dialog" persistent)
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
            :data="clients"
            :pagination.sync="pagination"
            :selected-rows-label="getSelectedString"
            :selected.sync="clients_selected"
            :visible-columns=['fullname', 'email', 'phone'])
        q-card-section
          span Companies
          q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:10px;"
            v-bind:disabled="isCompaniesDelBtnDisabled"
            @click="onDeleteCompanies")
          q-btn(label="Create" color="primary" @click="company_dialog = true" glossy dense)
          q-dialog(v-model="company_dialog" persistent)
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
                  div
                    q-btn(label="Submit" type="submit" color="primary")
                    q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
                    q-btn(flat label="Cancel" color="primary" v-close-popup)
          br
          q-table(dense row-key="name" selection="multiple"
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
      client_dialog: false,
      company_dialog: false,
      company: {
        name: '',
        inn: '',
        juristic_type_id: '',
        ogrn: ''
      }
    }
  },
  props: ['staff_paths'],
  methods: {
    onSubmitClient(evt) {
      this.sendClient(this.client);
    },
    onSubmitCompany(evt) {
      this.sendCompany(this.company);
    },
    onReset(entity) {
      for(let key in entity){
        entity[key] = '';
      }
    },
    async sendClient(client) {
      try {
        const response = await this.$api.post(this.staff_paths.client_create, client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async sendCompany(company) {
      try {
        const response = await this.$api.post(this.staff_paths.company_create, company);
        await this.getCompanies();
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
    async getJuristicTypes() {
      try {
        const response = await this.$api.get(this.staff_paths.juristic_types);
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
    this.getJuristicTypes();
    this.getClients();
    this.getCompanies();
  }
}
</script>

<style scoped>
</style>
