<template lang="pug">
  div
    q-btn(label="Delete" type="Delete" color="primary" glossy dense style="margin:5px;"
      v-bind:disabled="isClientsDelBtnDisabled"
      @click="deleteClients")
    q-btn(label="Create" color="primary" @click="qDialogs.client_new = true" glossy dense)
    q-dialog(v-model="qDialogs.client_new" persistent)
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
      :data="clients"
      :pagination.sync="pagination"
      :selected-rows-label="getSelectedString"
      :selected.sync="clients_selected"
      :visible-columns=['fullname', 'email', 'phone'])
    router-view
</template>

<script>
import functions from "../../utils/functions";
import VALIDATORS from "../../utils/validators";
import ERRORS from "../../utils/errors";

export default {
  data() {
    return {
      clients: [],
      errors: [],
      client: {
        fullname: '',
        email: '',
        phone: ''
      },
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
      clients_selected: [],
      qDialogs: {
        client_new: false
      },
    }
  },
  methods: {
    reset(entity) {
      functions.resetEntity(entity);
    },
    async sendClient(client) {
      try {
        this.qDialogs.client_new = false;
        const response = await this.$api.clients.create(client);
        this.reset(this.client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getClients() {
      try {
        const response = await this.$api.clients.index();
        this.clients = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async deleteClients() {
      try {
        let clients_selected = { ids:  this.clients_selected.map(client => client.id ) };
        const response = await this.$api.clients.delete(clients_selected);
        this.clients_selected = [];
        await this.getClients();
      } catch(err) {
        this.errors.push(err);
      }
    },
    getSelectedString () {
      return this.clients_selected.length === 0 ? '' :
          `${this.clients_selected.length} record${this.clients_selected.length > 1 ? 's' : ''} selected of ${this.clients.length}`
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
      return this.clients_selected.length === 0;
    }
  },
  mounted() {
    this.getClients();
  }
}
</script>

<style scoped>
</style>