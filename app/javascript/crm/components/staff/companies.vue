<template lang="pug">
  span Companies
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isCompaniesDelBtnDisabled"
      @click="deleteCompanies")
    q-btn(label="Create" color="primary" @click="qDialogs.company_new = true" glossy dense style="margin:5px;")
    q-dialog(v-model="qDialogs.company_new" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="sendCompany(company)" @reset="reset(company)")
            q-input(filled label="Company name *"
              v-model="company.name"
              lazy-rules :rules="[ val => val && val.length > 2 || 'Please type name > 2 chars']")
            q-input(filled type="number" label="INN" hint="Company inn"
              v-model="company.inn"
              lazy-rules :rules="[ val => val && val.toString().length > 9 || 'Please type INN > 9 only digits']")
            q-input(filled type="number" label="Company OGRN *"
              v-model="company.ogrn"
              lazy-rules :rules="[ val => val && val.toString().length > 9 || 'Please type OGRN > 9 only digits']")
            q-select(
              v-model="company.juristic_type_id" label="Juristic type"
              :options="juristic_types" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            q-btn(label="Submit" type="submit" color="primary" glossy dense)
            q-btn(label="Load from Dadata" color="primary" @click="qDialogs.dadata_new = true" glossy dense)
            q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
            q-btn(flat label="Cancel" color="primary" v-close-popup)
    dadata(:dadata_new.sync="qDialogs.dadata_new" v-on:dadata_company="onSetDadata")
    br
    q-table(dense row-key="name" selection="multiple"
      :data="companies"
      @row-dblclick="onDblClickCompaniesTable"
      option-label="name"
      :pagination.sync="pagination"
      :selected.sync="companies_selected"
      :selected-rows-label="getSelectedString"
      :visible-columns=['name', 'inn', 'jur_type', 'ogrn'])
    q-dialog(v-model="qDialogs.company_edit" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="onEditCompany")
            q-input(filled dense label="Company name *"
              v-model="company.name"
              lazy-rules :rules="[ val => val && val.length > 2 || 'Please type name > 2 chars']")
            q-input(filled dense type="number" label="INN" hint="Company inn"
              v-model="company.inn"
              lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type INN > 10 only digits']")
            q-input(filled dense type="number" label="Company OGRN *"
              v-model="company.ogrn"
              lazy-rules :rules="[ val => val && val.toString().length > 10 || 'Please type OGRN > 10 only digits']")
            q-select(
              v-model="company.juristic_type_id" label="Juristic type"
              :options="juristic_types" option-value="id" option-label="name"
              emit-value map-options dense
              transition-show="flip-up" transition-hide="flip-down")
            p(dense) Bind with clients:
            q-select(
              v-model="company_clients" label="Clients"
              multiple counter use-chips dense
              :options="clients" option-value="id" option-label="fullname"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            p(dense) Bind with devices:
            q-select(
              v-model="company_devices" label="Devices"
              multiple counter use-chips dense
              :options="devices" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Update" type="submit" color="primary")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
</template>

<script>
import functions from "../../utils/functions";
import dadata from "./dadata";

export default {
  components: {
    dadata: dadata,
  },
  data() {
    return {
      clients: [],
      devices: [],
      client_companies: [],
      company_clients: [],
      old_company_clients: [],
      company_devices: [],
      old_company_devices: [],
      companies: [],
      juristic_types: [],
      errors: [],
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
      companies_selected: [],
      company: {
        id: '',
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
        dadata_new: false
      },
    }
  },
  methods: {
    onSetDadata(value){
      this.company = value;
      this.qDialogs.dadata_new = false;
    },
    onEditCompany(evt) {
      this.editCompany();
      this.rebindRefsData();
      this.qDialogs.company_edit = false;
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async editCompany() {
      try {
        const response = await this.$api.companies.update(this.company);
        await this.getCompanies();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async rebindRefsData() {
      try {
        let new_client_ids = functions.arrDiffs(this.company_clients, this.old_company_clients);
        let del_client_ids = functions.arrDiffs(this.old_company_clients, this.company_clients);
        let new_device_ids = functions.arrDiffs(this.company_devices, this.old_company_devices);
        let del_device_ids = functions.arrDiffs(this.old_company_devices, this.company_devices);
        let data = { id: this.company.id, new_client_ids: new_client_ids, del_client_ids: del_client_ids,
          new_device_ids: new_device_ids, del_device_ids: del_device_ids};
        const response = await this.$api.companies.rebind_refs_data(data);
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
    async getCompanies() {
      try {
        const response = await this.$api.companies.index();
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getDevices() {
      try {
        const response = await this.$api.devices.index();
        this.devices = response.data;
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
      return this.companies_selected.length === 0 ? '' :
          `${this.companies_selected.length} record${this.companies_selected.length > 1 ? 's' : ''} selected of ${this.companies.length}`
    },
    onDblClickCompaniesTable(evt, row, index) {
      this.company = Object.assign({},row);
      this.getCompanyClients(row);
      this.getCompanyDevices(row);
      this.qDialogs.company_edit = true;
    },
    async getCompanyClients(company) {
      try {
        const response = await this.$api.companies.clients(company);
        this.company_clients = response.data;
        this.old_company_clients = this.company_clients;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async getCompanyDevices(company) {
      try {
        const response = await this.$api.companies.devices(company);
        this.company_devices = response.data;
        this.old_company_devices = this.company_devices;
      } catch(err) {
        this.errors.push(err);
      }
    }
  },
  computed: {
    isCompaniesDelBtnDisabled() {
      return this.companies_selected.length === 0;
    }
  },
  mounted() {
    this.getJuristicTypes();
    this.getCompanies();
    this.getClients();
    this.getDevices();
  }
}
</script>

<style scoped>
</style>
