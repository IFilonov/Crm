<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "client_email" :user_logout_path="$api.client.logout")
      dashboard(:client_id = "client_id" )
</template>

<script>
import navbar from '../shared/navbar';
import dashboard from './dashboard';
import { mapActions } from 'vuex';

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      client_email: null,
      client_id: null
    }
  },
  methods: {
    ...mapActions(['getJurTypes']),
    async clientEmail() {
      const response = await this.$api.clients.info();
      this.client_email = response.data.client_email;
      this.client_id = response.data.id;
    }
  },
  mounted() {
    this.clientEmail();
    this.getJurTypes();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
