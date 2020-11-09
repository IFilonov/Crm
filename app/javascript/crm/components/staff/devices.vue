<template lang="pug">
  div
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isDevicesDelBtnDisabled"
      @click="deleteDevices")
    q-btn(label="Create" color="primary" @click="dlg = true" glossy dense)
    q-dialog(v-model="dlg" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="sendDevice(device)" @reset="reset(device)")
            q-input(filled label="Device name"
              v-model="device.name"
              lazy-rules :rules="[ val => val && val.length > 0 || 'Please type device name']")
            q-input(filled label="Device type"
              v-model="device.type"
              lazy-rules :rules="[ val => val && val.length > 0 || 'Please enter device type']")
            q-input(filled label="Device serial number"
              v-model="device.serial"
              lazy-rules :rules="[ val => val && val.length > 0 || 'Please type device serial number']")
            q-select(
              v-model="device.company_id" label="Company"
              :options="$store.state.companies" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
    br
    q-table(dense row-key="serial" selection="multiple"
      @row-dblclick="onDblClickDevicesTable"
      :data="$store.state.devices"
      :pagination.sync="pagination"
      :selected-rows-label="getSelectedString"
      :selected.sync="selected"
      :visible-columns=['name', 'type', 'serial'])
      template(v-slot:loading)
        q-inner-loading(showing)
          q-spinner-dots(size="50px" color="primary")
    router-view
</template>

<script>
import functions from "../../utils/functions";
import entityLoads from "../../mixins/entity_loads";
import notifications from "../../mixins/notifications";

export default {
  mixins: [entityLoads,notifications],
  data() {
    return {
      pagination: {
        rowsPerPage: 5 // current rows per page being displayed
      },
      dlg: false,
      loading: true
    }
  },
  methods: {
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendDevice(device) {
      try {
        this.dlg = false;
        const response = await this.$api.devices.create(device);
        this.reset(this.device);
        this.showNotif("Device created");
        await this.$store.dispatch('getDevices');
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async deleteDevices() {
      try {
        let devices_selected = { ids:  this.selected.map(device => device.id) };
        const response = await this.$api.devices.delete(devices_selected);
        this.selected = [];
        this.showNotif("Device(s) deleted");
        await this.$store.dispatch('getClients');
      } catch(err) {
        this.errors.push(err);
      }
    },
    onDblClickDevicesTable(evt, row, index) {
      let id = row.id;
      this.$router.push({ name: 'Device_edit', params: { id } });
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
          `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.selected.length}`
    }
  },
  computed: {
    isDevicesDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.$store.dispatch('getDevices')
        .finally(() => ( this.loading = false ))
    this.$store.dispatch('getCompanies');
  },
  watch:{
    $route (to, from){
      if (this.$route.name === 'Devices') {
        this.$store.dispatch('getDevices');
      }
    }
  }
}
</script>

<style scoped>
</style>
