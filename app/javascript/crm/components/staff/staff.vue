<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "staff_email" :user_logout_path="staff_paths.staff_logout")
      dashboard(:staff_paths="staff_paths")
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
      staff_paths: {
        staff_email: "/staffs/staff_email",
        staff_logout: "/staffs/staff_logout",
        clients: "/clients",
        client_create: "/clients/create",
        clients_delete: "/clients/delete",
        companies: "/companies",
        companies_delete: "/companies/delete",
      },
      staff_email: null
    }
  },
  methods: {
    async staffEmail() {
      const response = await this.$api.get(this.staff_paths.staff_email);
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
