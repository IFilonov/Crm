<template lang="pug">
  #dashboard
    q-page-container
      q-card
        q-card-section
          div(class="q-pa-md")
            q-table(title="Companies" dense :data="client_companies" row-key="name"
              :pagination.sync="pagination"
              class="text-primary"
              :filter="filter"
              :loading="loading")
              template(v-slot:loading)
                q-inner-loading(showing)
                  q-spinner-dots(size="50px" color="primary")
              template(v-slot:top-right)
                q-input(borderless dense debounce="300" v-model="filter" placeholder="Search")
                  template(v-slot:append)
                    q-icon(name="fas fa-search")
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  data: function () {
    return {
      errors: [],
      pagination: {
        rowsPerPage: process.env.COMPANIES_PER_PAGE // current rows per page being displayed
      },
      loading: true,
      filter: ''
    }
  },
  props: ['client_id'],
  methods: {
    ...mapActions(['getClientCompanies','setClientCompanies'])
  },
  mounted() {
    this.getClientCompanies()
      .finally(() => ( this.loading = false )),
    this.$cable.subscribe({
      channel: 'ClientCompaniesChannels'
    });
  },
  computed: {
    ...mapState(['client_companies','juristic_types'])
  },
  channels: {
    ClientCompaniesChannels: {
      received(data) {
        let new_client_companies = this.client_companies;
        if( data.client_id === this.client_id) {
          let new_client_company = (({name, jur_type, inn, ogrn}) => ({
            name,
            jur_type,
            inn,
            ogrn
          }))(data.company);
          new_client_company.jur_type = this.juristic_types.find(jur_type => jur_type.id === data.company.juristic_type_id).name
          new_client_companies.unshift(new_client_company);
          this.setClientCompanies(new_client_companies);
        }
      }
    }
  }
}
</script>

<style scoped>
</style>
