<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "staff_email" :user_logout_path="staff_logout_path")
      dashboard(:clients_path="clients_path" :client_create_path="client_create_path")
</template>

<script>
import navbar from "../shared/navbar";
import dashboard from "./dashboard";
import { QSpinnerGrid } from 'quasar'

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      staff_email_path: "/staffs/staff_email",
      staff_logout_path: "/staffs/staff_logout",
      clients_path: "/clients",
      client_create_path: "/clients/create",
      staff_email: null
    }
  },
  methods: {
    async staffEmail() {
      const response = await this.$api.get(this.staff_email_path);
      this.staff_email = response.data.staff_email;
    },
    showLoading () {
      this.$q.loading.show({
        spinner: QSpinnerGrid,
        spinnerColor: 'purple',
        spinnerSize: 80
      });
    }
  },
  beforeMount() {
    this.showLoading();
  },
  mounted() {
    this.staffEmail();
    setTimeout(() => {
      this.$q.loading.hide()
    }, 1000);
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
