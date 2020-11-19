<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered side="left" behavior="desktop" elevated)
      q-list(bordered padding class="rounded-borders text-primary text-bold")
        q-item(clickable v-ripple active-class="my-menu-link" :to="{ name: 'Clients'}")
          q-item-section(avatar)
            q-icon(name="fas fa-users-cog")
          q-item-section Clients
        q-item(clickable v-ripple active-class="my-menu-link" :to="{ name: 'Companies'}")
          q-item-section(avatar)
            q-icon(name="fas fa-globe")
          q-item-section Companies
        q-item(clickable v-ripple active-class="my-menu-link" :to="{ name: 'Devices'}")
          q-item-section(avatar)
            q-icon(name="fas fa-cubes")
          q-item-section Devices
    q-page-container
      q-card
        q-tabs(active-bg-color="amber" indicator-color="amber" align="left")
          q-route-tab(label="Clients" :to="{ name: 'Clients' }" class="text-primary")
          q-route-tab(label="Companies" :to="{ name: 'Companies' }" class="text-primary")
          q-route-tab(label="Devices" :to="{ name: 'Devices' }" class="text-primary")
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

<style lang="sass">
</style>
