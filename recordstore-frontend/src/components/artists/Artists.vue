
<template>
  <div class="">
    <div class="" v-if="error">{{ error }}</div>
    <h3 class="">Add a new artist</h3>
    <form action="" @submit.prevent="addArtist">
      <div class="">
        <input class=""
          autofocus autocomplete="off"
          placeholder="Type an arist name"
          v-model="newArtist.name" />
      </div>
      <input type="submit" value="Add Artist" class="" />
    </form>

    <hr class="" />

    <ul class="">
      <li class="" v-for="artist in artists" :key="artist.id" :artist="artist">

        <div class="">
          <p class="">
            {{ artist.name }}
          </p>

          <button class=""
          @click.prevent="editArtist(artist)">Edit</button>

          <button class=""
         @click.prevent="removeArtist(artist)">Delete</button>
        </div>

        <div v-if="artist == editedArtist">
          <form action="" @submit.prevent="updateArtist(artist)">
            <div class="">
              <input class="" v-model="artist.name" />
              <input type="" value="Update" class="">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Artists',
  data () {
    return {
      artists: [],
      newArtist: [],
      error: '',
      editedArtist: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/artists')
        .then(response => { this.artists = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addArtist () {
      const value = this.newArtist
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/artists/', { artist: { name: this.newArtist.name } })

        .then(response => {
          this.artists.push(response.data)
          this.newArtist = ''
        })
        .catch(error => this.setError(error, 'Error Creating artist'))
    },
    removeArtist (artist) {
      this.$http.secured.delete(`/api/v1/artists/${artist.id}`)
        .then(response => {
          this.artists.splice(this.artists.indexOf(artist), 1)
        })
        .catch(error => this.setError(error, 'Error Deleting artist'))
    },
    editArtist (artist) {
      this.editedArtist = artist
    },
    updateArtist (artist) {
      this.editedArtist = ''
      this.$http.secured.patch(`/api/v1/artists/${artist.id}`, { artist: { name: artist.name } })
        .catch(error => this.setError(error, 'Error Updating artist'))
    }
  }
}
</script>
