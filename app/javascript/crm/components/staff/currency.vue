<template lang="pug">
  div
    q-table(
      grid
      card-class="bg-primary text-white glossy text-bold"
      color="blue"
      :title="currency.base + ' on ' + currency.date"
      title-class="text-primary"
      :data="rates"
      row-key="name"
      :filter="filter"
      :pagination.sync="pagination"
      :rows-per-page-options="rowsPerPageOptions"
      hide-header)
       template(v-slot:top-right)
         q-input(borderless dense debounce="300" v-model="filter" placeholder="Search")
           template(v-slot:append)
              q-icon(name="search")
</template>

<script>
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      showEditDeviceDlg: false,
      filter: '',
      pagination: {
        page: 1,
        rowsPerPage: this.getItemsPerPage()
      }
    }
  },
  methods: {
    ...mapActions(['fetchCurrency']),
    onHide() {
      this.$router.push({ name: 'Devices' });
    },
    getItemsPerPage () {
      const { screen } = this.$q
      if (screen.lt.sm) {
        return 3
      }
      if (screen.lt.md) {
        return 6
      }
      return 24
    }
  },
  computed: {
    ...mapState(['currency','rates']),
    id() {
      return this.$route.params.id;
    },
    rowsPerPageOptions () {
      if (this.$q.screen.gt.xs) {
        return this.$q.screen.gt.sm ? [ 3, 6, 9 ] : [ 3, 6 ]
      }
      return [ 3 ]
    }
  },
  mounted() {
    this.fetchCurrency();
  }
}
</script>
