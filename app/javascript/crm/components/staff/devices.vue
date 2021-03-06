<template lang="pug">
  span
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isDevicesDelBtnDisabled"
      @click="deleteDevices")
    q-btn(label="Create" color="primary" @click="dlg = true" glossy dense style="margin:5px;")
    q-btn(label="Modify" color="primary" glossy dense style="margin:5px;")
      q-popup-proxy(transition-show="flip-up" transition-hide="flip-down")
        q-banner(class="bg-purple text-white") For edit, please, make doubleclick on row of data below
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
              :options="companies" option-value="id" option-label="name"
              emit-value map-options
              transition-show="flip-up" transition-hide="flip-down")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
    div(class="q-pa-md")
      q-table(dense row-key="serial" selection="multiple" class="text-primary"
        @row-dblclick="onDblClickDevicesTable"
        :data="devices"
        :pagination.sync="pagination"
        :selected-rows-label="getSelectedString"
        :selected.sync="selected"
        :loading="loading"
        :visible-columns=['name', 'type', 'serial'])
        template(v-slot:loading)
          q-inner-loading(showing)
            q-spinner-dots(size="50px" color="primary")
    router-view
</template>

<script>
import functions from 'functions';
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads,notifications],
  data() {
    return {
      pagination: {
        rowsPerPage: process.env.DEVICES_PER_PAGE // current rows per page being displayed
      },
      dlg: false
    }
  },
  methods: {
    ...mapActions(['getCompanies','getDevices']),
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendDevice(device) {
      try {
        this.dlg = false;
        await this.$api.devices.create(device);
        this.reset(this.device);
        this.showNotif('Device created');
        this.loading = true;
        await this.getDevices()
          .finally(() => ( this.loading = false ))
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async deleteDevices() {
      try {
        let devices_selected = { ids:  this.selected.map(device => device.id) };
        await this.$api.devices.delete(devices_selected);
        this.selected = [];
        this.showNotif('Device(s) deleted');
        this.loading = true;
        await this.getDevices()
          .finally(() => ( this.loading = false ))
      } catch(err) {
        this.errors.push(err);
      }
    },
    onDblClickDevicesTable(evt, row) {
      let id = row.id;
      this.$router.push({ name: 'Device_edit', params: { id } });
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
        `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.selected.length}`
    }
  },
  computed: {
    ...mapState(['companies','devices']),
    isDevicesDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.getDevices()
      .finally(() => ( this.loading = false ))
    this.getCompanies();
  },
  watch:{
    $route (){
      if (this.$route.name === 'Devices') {
        this.loading = true;
        this.getDevices()
          .finally(() => ( this.loading = false ))
      }
    }
  }
}
</script>
