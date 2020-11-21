<template lang="pug">
  div(class="q-pa-md")
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isCompaniesDelBtnDisabled"
      @click="deleteCompanies")
    q-btn(label="Create" color="primary" @click="qDialogs.company_new = true" glossy dense style="margin:5px;")
    q-btn(label="Modify" color="primary" glossy dense style="margin:5px;")
      q-popup-proxy(transition-show="flip-up" transition-hide="flip-down")
        q-banner(class="bg-purple text-white") For edit, please, make doubleclick on row of data below
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
    div(class="q-pa-md")
      q-table(dense row-key="name" selection="multiple" class="text-primary"
        :data="companies"
        binary-state-sort=false
        @row-dblclick="onDblClickCompaniesTable"
        option-label="name"
        :pagination.sync="pagination"
        :selected.sync="selected"
        :filter="filter"
        :selected-rows-label="getSelectedString"
        :visible-columns=['name', 'inn', 'jur_type', 'ogrn'])
        template(v-slot:top-right)
          q-input(borderless dense debounce="300" v-model="filter" placeholder="Search")
            template(v-slot:append)
              q-icon(name="fas fa-search")
        template(v-slot:loading)
          q-inner-loading(showing)
            q-spinner-dots(size="50px" color="primary")
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
    dadata(:dadata_new.sync="qDialogs.dadata_new" @dadata-company="onSetDadata")
</template>

<script>
import dadata from './dadata';
import functions from 'functions';
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads, notifications],
  components: {
    dadata: dadata,
  },
  data() {
    return {
      client_companies: [],
      company_clients: [],
      old_company_clients: [],
      company_devices: [],
      old_company_devices: [],
      pagination: {
        rowsPerPage: process.env.COMPANIES_PER_PAGE
      },
      qDialogs: {
        company_new: false,
        company_edit: false,
        dadata_new: false
      },
      filter: '',
      loading: true
    }
  },
  methods: {
    ...mapActions(['getClients','getCompanies','getDevices','setCompanies']),
    onSetDadata(value){
      this.company = value;
      this.qDialogs.dadata_new = false;
    },
    onEditCompany() {
      this.editCompany();
      this.rebindRefsData();
      this.qDialogs.company_edit = false;
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async editCompany() {
      try {
        await this.$api.companies.update(this.company);
        this.showNotif('Company updated');
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
        await this.$api.companies.rebind_refs_data(data);
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async sendCompany(company) {
      try {
        this.qDialogs.company_new = false;
        await this.$api.companies.create(company);
        this.reset(this.company);
        this.showNotif('Company created');
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async deleteCompanies() {
      try {
        let companies_selected = { ids:  this.selected.map(company => company.id ) } ;
        await this.$api.companies.delete(companies_selected);
        this.selected = [];
        this.showNotif('Company(ies) deleted');
        await this.getCompanies();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
        `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.companies.length}`
    },
    onDblClickCompaniesTable(evt, row) {
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
    ...mapState(['clients', 'companies', 'devices', 'juristic_types']),
    isCompaniesDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.getClients();
    this.getDevices();
    this.getCompanies()
      .finally(() => ( this.loading = false ));
    this.$cable.subscribe({
      channel: 'CompaniesChannels'
    });
  },
  channels: {
    CompaniesChannels: {
      received(data) {
        let new_companies = functions.arrFilterById(this.companies, data.company.id);
        let jur_type = functions.arrFilterById(this.juristic_types, data.company.juristic_type_id);
        let new_company = (({ id, name, juristic_type_id, inn, ogrn }) => ({ id, name, juristic_type_id, inn, ogrn }))(data.company);
        new_company.jur_type = jur_type[0].name;
        new_companies.push(new_company);
        this.setCompanies(new_companies);
      }
    }
  }
}
</script>
