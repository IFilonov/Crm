<template lang="pug">
  #staff
    q-layout(view="hHh lPr fff")
      navbar(:user_email = "staff_email" :user_logout_path="staff_logout_path")
      dashboard()
</template>

<script>
import navbar from "../shared/navbar";
import dashboard from "./dashboard";
import { QSpinnerGrid } from 'quasar';
import paths from '../../api/paths';

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      staff_email: null,
      staff_logout_path: paths.staff_logout
    }
  },
  methods: {
    async staffEmail() {
      const response = await this.$api.get(paths.staff_email);
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
