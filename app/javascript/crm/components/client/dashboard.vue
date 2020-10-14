<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
      q-card
        q-card-section
    q-page-container
      q-card
        q-card-section
          q-table(title="Companies" dense :data="companies" row-key="name" :pagination.sync="pagination")
</template>

<script>
export default {
  data() {
    return {
      companies: [],
      errors: [],
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
    }
  },
  methods: {
    async getCompanies() {
      try {
        const response = await this.$api.client.companies()
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
  },
  mounted() {
    this.getCompanies();
  }
}
</script>

<style scoped>
</style>
