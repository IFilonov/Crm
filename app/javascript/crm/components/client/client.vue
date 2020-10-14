<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "client_email" :user_logout_path="$api.client.logout")
      dashboard()
</template>

<script>
import navbar from "../shared/navbar";
import dashboard from "./dashboard";

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      client_email: null
    }
  },
  methods: {
    async clientEmail() {
      const response = await this.$api.clients.email();
      this.client_email = response.data.client_email;
    }
  },
  mounted() {
    this.clientEmail();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
