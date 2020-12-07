<template lang="pug">
  q-dialog(v-model="showEditDeviceDlg" persistent @hide="onHide")
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
            q-btn(label="Update" type="submit" color="primary" glossy dense style="margin:5px;")
            q-btn(flat label="Cancel" color="primary" v-close-popup style="margin:5px;")
</template>

<script>
import functions from 'functions';
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
    ...mapActions(['getCompanies']),
    onHide() {
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
    onUpdate() {
      this.showEditDeviceDlg = false;
      this.edit();
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async edit() {
      try {
        await this.$api.devices.update(this.device);
        this.showNotif('Device updated');
      } catch(err)  {
        this.showErrNotif( { message: 'Device not updated ' , error: err } );
      }
    }
  },
  computed: {
    ...mapState(['companies']),
    id() {
      return this.$route.params.id;
    }
  },
  created() {
    this.getDeviceById();
    this.showEditDeviceDlg = true;
  }
}
</script>

<style scoped>
</style>
