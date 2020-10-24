<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
    q-page-container
      q-card
        q-btn(color="primary" label="Clients" :to="{ name: 'Clients' }")
        q-btn(color="secondary" label="Companies" :to="{ name: 'Companies' }")
        q-card-section
          router-view
</template>

<script>
import clients from "./clients";
import companies from "./companies";

export default {
  components: {
    clients: clients,
    companies: companies
  }
}
</script>

<style scoped>
</style>
