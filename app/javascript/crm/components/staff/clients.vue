<template lang="pug">
  span
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isClientsDelBtnDisabled"
      @click="deleteClients")
    q-btn(label="Create" color="primary" @click="dlg = true" glossy dense style="margin:5px;")
    q-btn(label="Modify" color="primary" glossy dense style="margin:5px;")
      q-popup-proxy(transition-show="flip-up" transition-hide="flip-down")
        q-banner(class="bg-purple text-white") For edit, please, make doubleclick on row of data below
    q-dialog(v-model="dlg" persistent)
      q-card
        q-card-section(class="row items-center")
          q-form(class="q-gutter-md" @submit="sendClient(client)" @reset="reset(client)")
            q-input(filled label="Your Fullname *" hint="Name and surname"
              v-model="client.fullname"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Fullname > 5 chars']")
            q-input(filled type="email" label="Your email *" hint="your@email.adr"
              v-model="client.email"
              :rules="[ val => validEmail ]")
            q-input(filled type="number" mask="phone" label="Your phone *"
              v-model="client.phone"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Phone > 5 only digits']")
            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
              q-btn(flat label="Cancel" color="primary" v-close-popup)
    div(class="q-pa-md")
      q-table(dense row-key="email" selection="multiple" class="text-primary"
        @row-dblclick="onDblClickClientsTable"
        :loading="loading"
        :data="clients"
        :pagination.sync="pagination"
        :selected-rows-label="getSelectedString"
        :selected.sync="selected"
        :visible-columns=['fullname', 'email', 'phone'])
        template(v-slot:loading)
          q-inner-loading(showing)
            q-spinner-dots(size="50px" color="primary")
    router-view
</template>

<script>
import functions from 'functions';
import VALIDATORS from 'validators';
import ERRORS from 'errors';
import entityLoads from 'entity_loads';
import notifications from 'notifications';
import { mapState, mapActions } from 'vuex'

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      pagination: {
        rowsPerPage: process.env.CLIENTS_PER_PAGE // current rows per page being displayed
      },
      dlg: false
    }
  },
  methods: {
    ...mapActions(['getClients']),
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendClient(client) {
      try {
        this.dlg = false;
        const response = await this.$api.clients.create(client);
        this.reset(this.client);
        response.data.length > 0 ? this.showErrNotif({ message: response.data } )
          : this.showNotif('Client created');
        await this.getClients();
      } catch(err)  {
        this.showErrNotif( { message: 'Client not created ' } );
      }
    },
    async deleteClients() {
      try {
        let clients_selected = { ids:  this.selected.map(client => client.id ) };
        await this.$api.clients.delete(clients_selected);
        this.selected = [];
        this.showNotif('Client(s) deleted');
        await this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
        `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.clients.length}`
    },
    onDblClickClientsTable(evt, row) {
      let id = row.id;
      this.$router.push({ name: 'Client_edit', params: { id } });
    }
  },
  computed: {
    ...mapState(['clients']),
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    },
    isClientsDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.getClients()
      .finally(() => ( this.loading = false ))
  }
}
</script>

<style scoped>
</style>
