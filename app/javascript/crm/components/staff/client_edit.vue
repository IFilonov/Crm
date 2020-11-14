<template lang="pug">
  q-dialog(v-model="dlg" persistent @hide="onHide")
    q-card
      q-card-section(class="row items-center")
        q-form(class="q-gutter-md" @submit="onUpdate")
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
            :options="$store.state.companies" option-value="id" option-label="name"
            emit-value map-options
            transition-show="flip-up" transition-hide="flip-down")
          div
            q-btn(label="Reset password" color="primary" @click="onResetPassword" glossy dense style="margin:5px;")
          div
            q-btn(label="Update" type="submit" color="primary" glossy dense style="margin:5px;")
            q-btn(flat label="Cancel" color="primary" v-close-popup style="margin:5px;")
</template>

<script>
import functions from 'functions';
import VALIDATORS from 'validators';
import ERRORS from 'errors';
import entityLoads from 'entity_loads';
import notifications from 'notifications';

export default {
  mixins: [entityLoads, notifications],
  data() {
    return {
      dlg: false,
      client_companies: [],
      old_client_companies: [],
    }
  },
  methods: {
    onHide() {
      this.$router.push({ name: 'Clients' });
    },
    async getClientById() {
      try {
        const response = await this.$api.clients.get({ id: this.id });
        this.client = response.data;
        await this.getClientCompanies();
      } catch(err) {
        this.errors.push(err);
      }
    },
    onUpdate() {
      this.dlg = false;
      this.update();
      this.rebindCompaniesToClient();
    },
    onResetPassword(){
      this.resetPassword();
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
    async resetPassword() {
      try {
        await this.$api.clients.reset({ id: this.id });
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async update() {
      try {
        await this.$api.clients.update(this.client);
        this.showNotif('Client updated');
        await this.$store.dispatch('getClients');
      } catch(err)  {
        this.errors.push(err);
      }
    },
    async rebindCompaniesToClient() {
      try {
        let new_company_ids = functions.arrDiffs(this.client_companies, this.old_client_companies);
        let del_company_ids = functions.arrDiffs(this.old_client_companies, this.client_companies);
        let companies = { client_id: this.client['id'], new_company_ids: new_company_ids, del_company_ids: del_company_ids }
        await this.$api.client_companies.rebind_companies(companies);
      } catch(err)  {
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
    this.$store.dispatch('getCompanies');
    this.dlg=true;
  }
}
</script>

<style scoped>
</style>
