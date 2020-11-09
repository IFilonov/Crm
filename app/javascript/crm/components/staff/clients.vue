<template lang="pug">
  div
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isClientsDelBtnDisabled"
      @click="deleteClients")
    q-btn(label="Create" color="primary" @click="dlg = true" glossy dense)
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
    br
    q-table(dense row-key="email" selection="multiple"
      @row-dblclick="onDblClickClientsTable"
      :loading="loading"
      :data="$store.state.clients"
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
import functions from "../../utils/functions";
import VALIDATORS from "../../utils/validators";
import ERRORS from "../../utils/errors";
import entityLoads from "../../mixins/entity_loads";
import notifications from "../../mixins/notifications";

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
      dlg: false,
      loading: true
    }
  },
  methods: {
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendClient(client) {
      try {
        this.dlg = false;
        const response = await this.$api.clients.create(client);
        this.reset(this.client);
         response.data.length > 0 ? this.showErrNotif({ message: response.data } )
            : this.showNotif("Client created");
        await this.$store.dispatch('getClients');
      } catch(err)  {
        this.showErrNotif( { message: "Client not created " } );
      }
    },
    async deleteClients() {
      try {
        let clients_selected = { ids:  this.selected.map(client => client.id ) };
        const response = await this.$api.clients.delete(clients_selected);
        this.selected = [];
        this.showNotif("Client(s) deleted");
        await this.$store.dispatch('getClients');
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.selected.length === 0 ? '' :
          `${this.selected.length} record${this.selected.length > 1 ? 's' : ''} selected of ${this.$store.state.clients.length}`
    },
    onDblClickClientsTable(evt, row, index) {
      let id = row.id;
      this.$router.push({ name: 'Client_edit', params: { id } });
    },
  },
  computed: {
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    },
    isClientsDelBtnDisabled() {
      return this.selected.length === 0;
    }
  },
  mounted() {
    this.$store.dispatch('getClients')
      .finally(() => ( this.loading = false ))
  }
}
</script>

<style scoped>
</style>
