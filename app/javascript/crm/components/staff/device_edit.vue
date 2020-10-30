<template lang="pug">
  q-dialog(v-model="dlg" persistent @hide="onHide")
    q-card
      q-card-section(class="row items-center")
        q-form(class="q-gutter-md" @submit="onUpdate")
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
            q-btn(label="Update" type="submit" color="primary" glossy dense  style="margin:5px;")
            q-btn(flat label="Cancel" color="primary" v-close-popup style="margin:5px;")
</template>

<script>
import functions from "../../utils/functions";
import entityLoads from "../../mixins/entity_loads";
import notifications from "../../mixins/notifications";

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      dlg: false
    }
  },
  methods: {
    onHide(evt) {
      this.$router.push({ name: 'Devices' });
    },
    async getDeviceById() {
      try {
        const response = await this.$api.devices.get({ id: this.id });
        this.device = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    onUpdate(evt) {
      this.dlg = false;
      this.edit();
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async edit() {
      try {
        const response = await this.$api.devices.update(this.device);
        this.showNotif("Device updated");
      } catch(err)  {
        this.showErrNotif( { message: "Device not updated " , error: err } );
      }
    }
  },
  computed: {
    id() {
      return this.$route.params.id;
    }
  },
  created() {
    this.getDeviceById();
    this.getCompanies();
    this.dlg = true;
  }
}
</script>

<style scoped>
</style>
