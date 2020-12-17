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
  methods: {
    ...mapActions(['getClientCompanies'])
  },
  mounted() {
    this.getClientCompanies()
      .finally(() => ( this.loading = false ))
  },
  computed: {
    ...mapState(['client_companies'])
  }
}
</script>

<style scoped>
</style>
