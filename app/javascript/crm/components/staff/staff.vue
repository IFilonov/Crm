<template lang="pug">
  div
    q-layout()
      navbar(:user_email = "staff_email" :user_logout_path="$api.staff.logout")
      dashboard
</template>

<script>
import navbar from '../shared/navbar';
import dashboard from './dashboard';
import { QSpinnerGrid } from 'quasar';
import { mapActions } from 'vuex'

export default {
  components: {
    'navbar': navbar,
    'dashboard': dashboard
  },
  data: function () {
    return {
      staff_email: null
    }
  },
  methods: {
    ...mapActions(['getJurTypes']),
    async staffEmail() {
      const response = await this.$api.staff.email();
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
    this.getJurTypes();
    setTimeout(() => {
      this.$q.loading.hide()
    }, 1000);
  }
}
</script>
