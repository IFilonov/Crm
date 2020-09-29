<template lang="pug">
  #dashboard
    b-card-group
      b-card(title="New Client" style="max-width: 20rem;" class="mb-2")
        b-form(@submit="onSubmit" @reset="onReset" v-if="show")
          b-form-group(
            id="input-group-1"
            label="Your Fullname:"
            label-for="input-2")
            b-form-input(
              id="input-2"
              v-model="form.fullname"
              placeholder="Enter name")
          b-form-group(
            id="input-group-2"
            label="Email address:"
            label-for="input-1"
            description="We'll never share your email with anyone else.")
            b-form-input(id="input-1" v-model="form.email" type="text"
                placeholder="Enter email")

          b-form-group(id="input-group-3" label="Phone:" label-for="input-3")
            b-form-input(
              id="input-3"
              v-model="form.phone"
              type="text"
              placeholder="Enter phone")

          b-button(type="submit" variant="primary") Submit
          b-button(type="reset" variant="danger") Reset
        b-card(class="mt-3" header="Form Data Result")
          pre(class="m-0") {{ form }}
      b-card
        b-table(striped hover :items="clients")
</template>

<script>
import ERRORS from "../../utils/errors";
import VALIDATORS from "../../utils/validators";
export default {
  data() {
    return {
      clients: [],
      errors: [],
      form: {
        fullname: '',
        email: '',
        phone: ''
      },
      show: true
    }
  },
  props: ['clients_path', 'client_create_path'],
  methods: {
    onSubmit(evt) {
      evt.preventDefault()
      if (this.form.fullname.length < 5) {
        this.errors.push(ERRORS.FULLNAME_EMPTY);
      }
      if (!this.form.email) {
        this.errors.push(ERRORS.EMAIL_EMPTY);
      } else if (!this.validEmail(this.form.email)) {
        this.errors.push(ERRORS.EMAIL_NOT_VALID);
      }
      let numbers = VALIDATORS.PHONE;
      if (!this.form.phone) {
        this.errors.push(ERRORS.PHONE_EMPTY);
      } else if (!this.form.phone.match(numbers)) {
          this.errors.push(ERRORS.PHONE_NOT_VALID);
      }
      if (!this.checkErrors())
      {
        this.sendCurrentClient(this.form);
        this.getClients();
        this.checkErrors();
      }
    },
    onReset(evt) {
      evt.preventDefault()
      // Reset our form values
      this.form.fullname = ''
      this.form.email = ''
      this.form.phone = ''
      // Trick to reset/clear native browser form validation state
      this.show = false
      this.$nextTick(() => {
        this.show = true
      })
    },
    validEmail: function (email) {
      let re = VALIDATORS.EMAIL;
      return re.test(email);
    },
    async sendCurrentClient (client) {
      try {
        const response = await this.$api.post(this.client_create_path, client);
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
    }

  },
  mounted() {
    this.getClients();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
