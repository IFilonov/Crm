<template lang="pug">
  div
    p {{ currency.base }}
    p {{ currency.date }}
      li(v-for="(value,rate,index) in currency.rates") {{ index }} - {{ rate }} - {{ value }}
</template>

<script>
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      showEditDeviceDlg: false
    }
  },
  methods: {
    ...mapActions(['fetchCurrency']),
    onHide() {
      this.$router.push({ name: 'Devices' });
    }
  },
  computed: {
    ...mapState(['currency']),
    id() {
      return this.$route.params.id;
    }
  },
  mounted() {
    this.fetchCurrency();
  }
}
</script>

<style scoped>
</style>
