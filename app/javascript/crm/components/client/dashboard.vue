<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
      q-card
        q-card-section
    q-page-container
      q-card
        q-card-section
          q-table(title="Companies" dense :data="$store.state.client_companies" row-key="name" :pagination.sync="pagination")
</template>

<script>
export default {
  data() {
    return {
      errors: [],
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
    }
  },
  methods: {
  },
  mounted() {
    this.$store.dispatch('getClientCompanies');
  }
}
</script>

<style scoped>
</style>
