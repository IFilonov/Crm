<template lang="pug">
  #staff
    navbar(:user_email_path="this.user_email_path" :user_logout_path="this.user_logout_path")
    dashboard(:clients_path="this.clients_path" :client_create_path="this.client_create_path")
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
      user_email_path: "/staffs/staff_email",
      user_logout_path: "/staffs/staff_logout",
      clients_path: "/clients",
      client_create_path: "/clients/create"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
