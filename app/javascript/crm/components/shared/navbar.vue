<template lang="pug">
  #navbar
    b-navbar(toggleable="lg" type="dark" variant="info")
      b-navbar-brand(href="#") NavBar
      b-navbar-toggle(target="nav-collapse")

      b-collapse(id="nav-collapse" is-nav)
        b-navbar-nav
          img(src="https://placekitten.com/g/30/30" alt="Kitten")

        b-navbar-nav(class="ml-auto")
          b-nav-item-dropdown(right)
            <!-- Using 'button-content' slot -->
            template(v-slot:button-content)
              em Hello, {{ user_email }}
            b-dropdown-item(:href="user_logout_path") Sign Out
</template>

<script>
export default {
  data: function () {
    return {
     }
  },
  props: ['user_email', 'user_logout_path']
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
