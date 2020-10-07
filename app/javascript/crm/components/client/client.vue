<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "client_email" :user_logout_path="client_logout_path")
      dashboard(:client_companies_path = "client_companies_path")
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
      client_email_path: "/clients/client_email",
      client_logout_path: "/clients/client_logout",
      client_companies_path: "/clients/companies",
      client_email: null
    }
  },
  methods: {
    async clientEmail() {
      const response = await this.$api.get(this.client_email_path);
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
