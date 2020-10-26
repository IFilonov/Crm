<template lang="pug">
  div
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isDevicesDelBtnDisabled"
      @click="deleteDevices")
    q-btn(label="Create" color="primary" @click="qDialogs.device_new = true" glossy dense)
    q-dialog(v-model="qDialogs.device_new" persistent)
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
              :options="companies" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
    br
    q-table(dense row-key="email" selection="multiple"
      @row-dblclick="onDblClickDevicesTable"
      :data="devices"
      :pagination.sync="pagination"
      :selected-rows-label="getSelectedString"
      :selected.sync="devices_selected"
      :visible-columns=['name', 'type', 'serial'])
    router-view
</template>

<script>
import functions from "../../utils/functions";

export default {
  data() {
    return {
      companies: [],
      devices: [],
      errors: [],
      device: {
        name: '',
        type: '',
        serial: '',
        company_id: ''
      },
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
      devices_selected: [],
      qDialogs: {
        device_new: false
      },
    }
  },
  methods: {
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendDevice(device) {
      try {
        this.qDialogs.device_new = false;
        const response = await this.$api.devices.create(device);
        this.reset(this.device);
        await this.getDevices();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getDevices() {
      try {
        const response = await this.$api.devices.index();
        this.devices = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async deleteDevices() {
      try {
        let devices_selected = { ids:  this.devices_selected.map(device => device.id) };
        const response = await this.$api.devices.delete(devices_selected);
        this.devices_selected = [];
        await this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.devices_selected.length === 0 ? '' :
          `${this.devices_selected.length} record${this.devices_selected.length > 1 ? 's' : ''} selected of ${this.devices_selected.length}`
    },
    onDblClickDevicesTable(evt, row, index) {
      let id = row.id;
      this.$router.push({ name: 'Device_edit', params: { id } });
    },
    async getCompanies() {
      try {
        const response = await this.$api.companies.index();
        this.companies = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    }
  },
  computed: {
    isDevicesDelBtnDisabled() {
      return this.devices_selected.length === 0;
    }
  },
  mounted() {
    this.getDevices();
    this.getCompanies();
  }
}
</script>

<style scoped>
</style>
