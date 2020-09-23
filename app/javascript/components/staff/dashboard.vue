<template>
  <div>
    <b-card
        title="New Client"
        img-src="https://picsum.photos/600/300/?image=25"
        img-alt="Image"
        img-top
        tag="article"
        style="max-width: 20rem;"
        class="mb-2"
    >
      <b-form @submit="onSubmit" @reset="onReset" v-if="show">
        <b-form-group id="input-group-1" label="Your Fullname:" label-for="input-2">
          <b-form-input
              id="input-2"
              v-model="form.fullname"
              required
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
              type="email"
              required
              placeholder="Enter email"
          ></b-form-input>
        </b-form-group>

        <b-form-group id="input-group-3" label="Phone:" label-for="input-3">
          <b-form-input
              id="input-3"
              v-model="form.phone"
              type="phone"
              required
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
      form: {
        fullname: '',
        email: '',
        phone: ''
      },
      show: true
    }
  },
  methods: {
    onSubmit(evt) {
      evt.preventDefault()
      alert(JSON.stringify(this.form))
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
