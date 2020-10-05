<template lang="pug">
  #dashboard
    q-drawer(show-if-above bordered)
      q-card
        q-card-section
          q-form(@submit="onSubmit" @reset="onReset" class="q-gutter-md")
            q-input(filled v-model="client.fullname" label="Your Fullname *" hint="Name and surname"
              lazy-rules :rules="[ val => val.length > 0 || 'Please type Fullname > 5 chars']")
            q-input(filled type="email" v-model="client.email" label="Your email *" hint="your@email.adr"
              :rules="[ val => validEmail ]")
            q-input(filled type="number" mask="phone" v-model="client.phone" label="Your phone *"
              lazy-rules :rules="[ val => val && val.length > 5 || 'Please type phone > 5 only digits']")

            div
              q-btn(label="Submit" type="submit" color="primary")
              q-btn(label="Reset" type="reset" color="primary" flat class="q-ml-sm")
    q-page-container
      q-card
        q-card-section
          q-table(title="Clients" dense :data="clients" row-key="name" :pagination.sync="pagination")
</template>

<script>
import ERRORS from "../../utils/errors";
import VALIDATORS from "../../utils/validators";
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
      show: true,
      pagination: {
        rowsPerPage: 20 // current rows per page being displayed
      },
    }
  },
  props: ['clients_path', 'client_create_path'],
  methods: {
    onSubmit(evt) {
      this.sendCurrentClient(this.client);
    },
    onReset(evt) {
      for(let key in this.client){
        this.client[key] = '';
      }
    },
    async sendCurrentClient (client) {
      try {
        const response = await this.$api.post(this.client_create_path, client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async getClients() {
      try {
        const response = await this.$api.get(this.clients_path);
        this.clients = response.data;
      } catch(err) {
        this.errors.push(err);
      }
    },
    checkErrors() {
      let is_err = this.errors.length > 0;
      if (is_err) {
        alert(this.errors)
        this.errors = [];
      }
      return is_err;
    },
  },
  computed: {
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    }
  },
  mounted() {
    this.getClients();
  }
}
</script>

<style scoped>
</style>
