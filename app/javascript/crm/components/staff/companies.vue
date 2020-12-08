<template lang="pug">
  span
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isCompaniesDelBtnDisabled"
      @click="deleteCompanies")
    q-btn(label="Create" color="primary" @click="qDialogs.company_new = true" glossy dense style="margin:5px;")
    q-btn(label="Modify" color="primary" glossy dense style="margin:5px;")
      q-popup-proxy(transition-show="flip-up" transition-hide="flip-down")
        q-banner(class="bg-purple text-white") For edit, please, make doubleclick on row of data below
    q-dialog(v-model="qDialogs.company_new" persistent)
      q-card
        q-card(class="text-white" style="background: radial-gradient(circle, #35a2ff 0%, #014a88 100%)")
          q-card-section(class="row items-center")
            div(class="text-h6 text-white") Load company from Dadata.ru
            q-select(filled v-model="dadata_company"
              clearable use-input hide-selected fill-input
              input-debounce="300"
              class="col-12"
              bg-color="white"
              label="Type 1st symbols company name (russian)..."
              :options="dadata_options"
              option-label="name"
              @filter="filterDadataAutoselect"
              @filter-abort="abortFilterDadata"
              @input="onSetDadata")
              template(v-slot:no-option)
                q-item
                  q-item-section(class="text-grey") No results
        q-card-section(class="row items-center")
          q-form(@submit="sendCompany(company)" @reset="reset(company)" class="col-12")
            q-input(filled label="Company NAME"
              v-model="company.name"
              lazy-rules :rules="[ val => val && val.length > 2 || 'Please type name > 2 chars']")
            div(class="q-gutter-md row")
              q-input(filled type="number" label="Company INN"
                v-model="company.inn"
                lazy-rules :rules="[ val => val && val.toString().length > 9 || 'Please type INN > 9 only digits']")
              q-input(filled type="number" label="Company OGRN"
                v-model="company.ogrn"
                lazy-rules :rules="[ val => val && val.toString().length > 9 || 'Please type OGRN > 9 only digits']")
            q-select(
              v-model="company.juristic_type_id" label="Juristic type" dense
              :options="juristic_types" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            br
            q-btn(label="Submit" type="submit" color="primary" glossy class="q-ml-sm")
            q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
            q-btn(flat label="Cancel" color="primary" v-close-popup)
    div(class="q-pa-md")
      q-table(dense row-key="name" selection="multiple" class="text-primary"
        :data="companies_part"
        :loading="loading"
        @row-dblclick="onDblClickCompaniesTable"
        option-label="name"
        :pagination.sync="pagination"
        :selected.sync="selected"
        :filter="filter"
        @request="onRequest"
        :selected-rows-label="getSelectedString"
        :visible-columns=['name', 'inn', 'jur_type', 'ogrn'])
        template(v-slot:top-right)
          q-input(borderless dense debounce="300" v-model="filter" placeholder="Search")
            template(v-slot:append)
              q-icon(name="fas fa-search")
        template(v-slot:loading)
          q-inner-loading(showing)
            q-spinner-dots(size="50px" color="primary")
    q-dialog(v-model="qDialogs.company_edit" persistent style="width: 400px; max-width: 60vw;")
      q-card(style="width: 360px; max-width: 60vw;")
        q-card-section(class="q-gutter")
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
            p Bind with clients:
            q-select(
              v-model="company_clients" label="Clients"
              multiple counter use-chips dense
              :options="clients" option-value="id" option-label="fullname"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            p Bind with devices:
            q-select(
              v-model="company_devices" label="Devices"
              multiple counter use-chips dense
              :options="devices" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Update" type="submit" color="primary"  class="shadow-7")
              q-btn(flat label="Cancel" color="primary" class="shadow-7" v-close-popup)
</template>

<script>
import functions from 'functions';
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      dadata_companies: [],
      dadata_options: [],
      dadata_company: '',
      client_companies: [],
      company_clients: [],
      old_company_clients: [],
      company_devices: [],
      old_company_devices: [],
      pagination: {
        rowsPerPage: process.env.COMPANIES_PER_PAGE,
        sortBy: 'desc',
        descending: false,
        page: 1,
        rowsNumber: 0
      },
      qDialogs: {
        company_new: false,
        company_edit: false
      },
      filter: ''
    }
  },
  methods: {
    ...mapActions(['getClients', 'getDevices', 'setCompaniesPart', 'getCompaniesPagination', 'getCompaniesCount']),
    onSetDadata(dadata_company){
      this.company = (Object.assign({},dadata_company));
    },
    onEditCompany() {
      this.editCompany();
      this.rebindRefsData();
      this.qDialogs.company_edit = false;
    },
    reset(entity) {
      functions.resetEntity(entity);
      this.dadata_options = [];
      this.dadata_company = '';
      this.dadata_companies = [];
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
        this.loading = true;
        await this.getCompaniesPagination( { page: this.pagination.page, per_page: this.pagination.rowsPerPage, filter_name: this.filter})
          .finally(() => ( this.loading = false ));
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
        `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.companies_count}`
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
    },
    async getDadataCompanies(filter) {
      try {
        this.dadata_companies = [];
        let dadata_filter = {
          query: filter
        };
        const response = await this.$api.dadata.index(dadata_filter);
        response.data.suggestions.forEach(element => {
          let company = {};
          company.name= element.data.name.full;
          company.inn = element.data.inn;
          company.ogrn = element.data.ogrn;
          this.dadata_companies.push(Object.assign({},company));
        })
        this.dadata_options = this.dadata_companies.filter(company => company.name.toLowerCase().indexOf(filter.toLowerCase()) > -1);
      } catch(err) {
        this.errors.push(err);
      }
    },
    filterDadataAutoselect (val, update) {
      // call abort() at any time if you can't retrieve data somehow
      update(
        () => {
          if (val.length > 0) {
            this.getDadataCompanies(val);
          } else {
            this.dadata_options = (Object.assign([], this.dadata_companies));
          }
        },
        ref => {
          if (val !== '' && ref.options.length > 0 && ref.optionIndex === -1) {
            ref.moveOptionSelection(1, true) // focus the first selectable option and do not update the input-value
            ref.toggleOption(ref.options[ref.optionIndex].name, true) // toggle the focused option
          }
        }
      )
    },
    abortFilterDadata () {
    },
    onRequest (props) {
      const { page, rowsPerPage, sortBy, descending } = props.pagination
      const filter_name = props.filter || ''
      this.loading = true

      this.getCompaniesCount();
      this.pagination.rowsNumber = this.companies_count;
      const fetchCount = rowsPerPage === 0 ? this.pagination.rowsNumber : rowsPerPage

      this.getCompaniesPagination( { page: page, per_page: fetchCount, filter_name: filter_name })
        .finally(() => (
          this.pagination.page = page,
          this.pagination.rowsPerPage = rowsPerPage,
          this.pagination.sortBy = sortBy,
          this.pagination.descending = descending,
          this.loading = false))
    },
  },
  computed: {
    ...mapState(['clients', 'companies_part', 'devices', 'juristic_types','companies_count']),
    isCompaniesDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.getCompaniesCount();
    this.pagination.rowsNumber = this.companies_count;
    this.getCompaniesPagination( { page: this.pagination.page, per_page: this.pagination.rowsPerPage, filter_name: ''})
      .finally(() => ( this.loading = false ));
    this.getClients();
    this.getDevices();
    this.$cable.subscribe({
      channel: 'CompaniesChannels'
    });
  },
  channels: {
    CompaniesChannels: {
      received(data) {
        let new_companies = functions.arrFilterById(this.companies_part, data.company.id);
        let new_company = (({ id, name, jur_type, inn, juristic_type_id, ogrn }) => ({ id, name, jur_type, inn, juristic_type_id, ogrn }))(data.company);
        new_company.jur_type = this.juristic_types.find(jur_type => jur_type.id === new_company.juristic_type_id).name
        new_companies.unshift(new_company);
        this.setCompaniesPart(new_companies);
      }
    }
  }
}
</script>
