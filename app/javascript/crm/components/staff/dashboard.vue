<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
    q-page-container
      q-card
        q-tabs(active-bg-color="amber" indicator-color="amber" align="left")
          q-route-tab(active-bg-color="red" label="Clients" :to="{ name: 'Clients' }")
          q-route-tab(color="secondary" label="Companies" :to="{ name: 'Companies' }")
          q-route-tab(color="amber" label="Devices" :to="{ name: 'Devices' }")
        q-card-section
          router-view
</template>

<script>
import clients from './clients';
import companies from './companies';

export default {
  components: {
    clients: clients,
    companies: companies
  }
}
</script>

<style scoped>
</style>
