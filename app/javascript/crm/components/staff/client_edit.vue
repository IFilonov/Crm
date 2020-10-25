<template lang="pug">
  q-dialog(v-model="clnt_edit" persistent @hide="onHide")
    q-card
      q-card-section(class="row items-center")
        q-form(class="q-gutter-md" @submit="onEditClient")
          q-input(filled label="Your Fullname *" hint="Name and surname"
            v-model="client.fullname"
            lazy-rules :rules="[ val => val && val.length > 5 || 'Please type Fullname > 5 chars']")
          q-input(filled type="email" label="Your email *" hint="your@email.adr"
            v-model="client.email"
            :rules="[ val => validEmail ]")
          q-input(filled type="number" mask="phone" label="Your phone *"
            v-model="client.phone"
            lazy-rules :rules="[ val => val && val.toString().length > 5 || 'Please type Phone > 5 only digits']")
          q-select(
            v-model="client_companies" label="Companies"
            multiple counter use-chips
            :options="companies" option-value="id" option-label="name"
            emit-value map-options
            transition-show="flip-up" transition-hide="flip-down")
          div
            q-btn(label="Update" type="submit" color="primary" glossy dense)
            q-btn(flat label="Cancel" color="primary" v-close-popup)
</template>

<script>
import functions from "../../utils/functions";
import VALIDATORS from "../../utils/validators";
import ERRORS from "../../utils/errors";

export default {
  data() {
    return {
      clnt_edit: false,
      client_companies: [],
      old_client_companies: [],
      companies: [],
      client: {
        fullname: '',
        email: '',
        phone: ''
      },
      errors: [],
    }
  },
  methods: {
    onHide(evt) {
      this.$router.push({ name: 'Clients' });
    },
    async getClientById() {
      try {
        let id = { id: this.id };
        const response = await this.$api.clients.get(id);
        this.client = response.data;
        await this.getClientCompanies();
      } catch(err) {
        this.errors.push(err);
      }
    },
    onEditClient(evt) {
      this.clnt_edit = false;
      this.editClient();
      this.rebindCompaniesToClient();
    },
    reset(entity) {
      functions.resetEntity(entity);
    },
    async getClientCompanies() {
      try {
        const response = await this.$api.companies.client_companies(this.client);
        this.client_companies = response.data;
        this.old_client_companies = this.client_companies;
      } catch(err) {
        this.errors.push(err);
      }
    },
    async editClient() {
      try {
        const response = await this.$api.clients.update(this.client);
        await this.getClients();
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async rebindCompaniesToClient() {
      try {
        let new_company_ids = functions.arrDiffs(this.client_companies, this.old_client_companies);
        let del_company_ids = functions.arrDiffs(this.old_client_companies, this.client_companies);
        let companies = { client_id: this.client["id"], new_company_ids: new_company_ids, del_company_ids: del_company_ids }
        const response = await this.$api.client_companies.rebind_companies(companies);
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
    validEmail() {
      return VALIDATORS.EMAIL.test(this.client.email) || ERRORS.EMAIL_NOT_VALID;
    },
    id() {
      return this.$route.params.id;
    }
  },
  created() {
    this.getClientById();
    this.getCompanies();
    this.clnt_edit=true;
    console.log(this.clnt_edit);
  }
}
</script>

<style scoped>
</style>
