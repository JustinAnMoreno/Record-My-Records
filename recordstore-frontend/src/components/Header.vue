<template>
  <header class="">
    <div class="">
      <div class="">
        <a href="/" class="">Record Store</a>
      </div>
      <div>
        <router-link to="/" class="" v-if="!signedIn()">Sign in</router-link>
        <router-link to="/signup" class="" v-if="!signedIn()">Sign Up</router-link>
        <router-link to="/records" class="" v-if="signedIn()">Records</router-link>
        <router-link to="/artists" class="" v-if="signedIn()">Artists</router-link>
        <a href="#" @click.prevent="signOut" class="" v-if="signedIn()">Sign out</a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  // No Data
  created () {
    this.signedIn()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    signedIn () {
      return localStorage.signedIn
    },
    signOut () {
    // Delete user local storage data/token
      this.$http.secured.delete('/signin')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          // Routes back to sign in page
          this.$router.replace('/')
        })
        .catch(error => this.setError(error, 'Unable to sign out'))
    }
  }
}
</script>

<style scoped>
</style>
