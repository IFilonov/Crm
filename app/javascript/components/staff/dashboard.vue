<template>
  <div>
    <b-card
        title="New Client"
        tag="article"
        style="max-width: 20rem;"
        class="mb-2"
    >
      <b-form @submit="onSubmit" @reset="onReset" v-if="show">
        <b-form-group id="input-group-1" label="Your Fullname:" label-for="input-2">
          <b-form-input
              id="input-2"
              v-model="form.fullname"
              placeholder="Enter name"
          ></b-form-input>
        </b-form-group>

        <b-form-group
            id="input-group-2"
            label="Email address:"
            label-for="input-1"
            description="We'll never share your email with anyone else."
        >
          <b-form-input
              id="input-1"
              v-model="form.email"
              type="text"
              placeholder="Enter email"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-3" label="Phone:" label-for="input-3">
          <b-form-input
              id="input-3"
              v-model="form.phone"
              type="text"
              placeholder="Enter phone"
          ></b-form-input>
        </b-form-group>

        <b-button type="submit" variant="primary">Submit</b-button>
        <b-button type="reset" variant="danger">Reset</b-button>
      </b-form>
      <b-card class="mt-3" header="Form Data Result">
        <pre class="m-0">{{ form }}</pre>
      </b-card>
    </b-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      errors: [],
      form: {
        fullname: '',
        email: '',
        phone: ''
      },
      show: true,
      errMsgs: Object.freeze({
        FULLNAME_EMPTY: 'Укажите имя не менее 5 символов',
        EMAIL_EMPTY: ' Укажите электронную почту',
        EMAIL_NOT_VALID: ' Укажите корректный адрес электронной почты',
        PHONE_EMPTY: ' Укажите номер телефона',
        PHONE_NOT_VALID: ' Укажите в телефоне только цифры'
      })
    }
  },
  methods: {
    onSubmit(evt) {
      evt.preventDefault()
      if (this.form.fullname.length < 5) {
        this.errors.push(this.errMsgs.FULLNAME_EMPTY);
      }
      if (!this.form.email) {
        this.errors.push(this.errMsgs.EMAIL_EMPTY);
      } else if (!this.validEmail(this.form.email)) {
        this.errors.push(this.errMsgs.EMAIL_NOT_VALID);
      }
      let numbers = /^[0-9]+$/;
      if (!this.form.phone) {
        this.errors.push(this.errMsgs.PHONE_EMPTY);
      } else if (!this.form.phone.match(numbers)) {
          this.errors.push(this.errMsgs.PHONE_NOT_VALID);
      }
      if (this.errors.length > 0) {
        alert(this.errors)
        this.errors = [];
      }
      else {
        alert(JSON.stringify(this.form))
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
      var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
