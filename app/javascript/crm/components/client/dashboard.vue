<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
      q-card
        q-card-section
    q-page-container
      q-card
        q-card-section
          q-table(title="Companies" dense :data="client_companies" row-key="name" :pagination.sync="pagination")
</template>

<script>
import { mapState, mapActions } from 'vuex'

export default {
  data: function () {
    return {
      errors: [],
      pagination: {
        rowsPerPage: process.env.COMPANIES_PER_PAGE // current rows per page being displayed
      }
    }
  },
  methods: {
    ...mapActions(['getClientCompanies'])
  },
  mounted() {
    this.getClientCompanies();
  },
  computed: {
    ...mapState(['client_companies'])
  }
}
</script>

<style scoped>
</style>
