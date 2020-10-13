<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "client_email" :user_logout_path="client_logout_path")
      dashboard()
</template>

<script>
import navbar from "../shared/navbar";
import dashboard from "./dashboard";
import paths from '../../api/paths';

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      client_email: null,
      client_logout_path: paths.client_logout
    }
  },
  methods: {
    async clientEmail() {
      const response = await this.$api.get(paths.client_email);
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
