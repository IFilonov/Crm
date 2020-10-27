<template lang="pug">
  q-dialog(v-model="device_edit" persistent @hide="onHide")
    q-card
      q-card-section(class="row items-center")
        q-form(class="q-gutter-md" @submit="onEditDevice")
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
import VALIDATORS from "../../utils/validators";
import ERRORS from "../../utils/errors";
import entityLoads from "../../mixins/entity_loads";

export default {
  mixins: [entityLoads],
  data() {
    return {
      device_edit: false,
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
    onEditDevice(evt) {
      this.device_edit = false;
      this.editDevice();
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async editDevice() {
      try {
        const response = await this.$api.devices.update(this.device);
      } catch(err)  {
        this.errors.push(err);
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
    this.device_edit=true;
  }
}
</script>

<style scoped>
</style>
