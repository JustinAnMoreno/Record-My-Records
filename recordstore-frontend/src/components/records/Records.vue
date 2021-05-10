<template>
  <div class="">
    <div class="" v-if="error">{{ error }}</div>
    <h3 class="">Add record</h3>
    <form action="" @submit.prevent="addRecord">
      <div class="">
        <label for="record_title" class="">Title</label>
        <input
          id="record_title"
          class=""
          autofocus autocomplete="off"
          placeholder="Input record name"
          v-model="newRecord.title" />
      </div>

      <div class="">
        <label for="record_year" class="">Year</label>
        <input
          id="record_year"
          class=""
          autofocus autocomplete="off"
          placeholder="Year"
          v-model="newRecord.year"
        />
       </div>

      <div class="">
        <label for="artist" class="">Artist</label>
        <select id="artist" class="" v-model="newRecord.artist">
          <option disabled value="">Select an artist</option>
          <option :value="artist.id" v-for="artist in artists" :key="artist.id">{{ artist.name }}</option>
        </select>
        <p class="">Missing artist? <router-link class="" to="/artists">Add one now!</router-link></p>
       </div>

      <input type="submit" value="Add Record" class="" />
    </form>

    <hr class="" />

    <ul class="">
      <li class="" v-for="record in records" :key="record.id" :record="record">

        <div class="">
          <div class="">
            <p class="">
              {{ record.title }} &mdash; {{ record.year }}
            </p>
            <p class="">{{ getArtist(record) }}</p>
          </div>
          <button class=""
          @click.prevent="editRecord(record)">Edit</button>

          <button class=""
         @click.prevent="removeRecord(record)">Delete</button>
        </div>

        <div v-if="record == editedRecord">
          <form action="" @submit.prevent="updateRecord(record)">
            <div class="">

              <div class="">
                <label class="">Title</label>
                <input class="" v-model="record.title" />
              </div>

              <div class="">
                <label class="">Year</label>
                <input class="" v-model="record.year" />
              </div>

              <div class="">
                <label class="">Artist</label>
                <select id="artist" class="" v-model="record.artist">
                  <option :value="artist.id" v-for="artist in artists" :key="artist.id">{{ artist.name }}</option>
                </select>
              </div>

              <input type="submit" value="Update" class="">
            </div>
          </form>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Records',
  data () {
    return {
      artists: [],
      records: [],
      newRecord: [],
      error: '',
      editedRecord: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/api/v1/records')
        .then(response => { this.records = response.data })
        .catch(error => this.setError(error, 'Problem getting data'))

      this.$http.secured.get('/api/v1/artists')
        .then(response => { this.artists = response.data })
        .catch(error => this.setError(error, 'Problem getting data'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    getArtist (record) {
      const recordArtistValues = this.artists.filter(artist => artist.id === record.artist_id)
      let artist

      recordArtistValues.forEach(function (element) {
        artist = element.name
      })

      return artist
    },
    addRecord () {
      const value = this.newRecord
      if (!value) {
        return
      }
      this.$http.secured.post('/api/v1/records/', { record: { title: this.newRecord.title, year: this.newRecord.year, artist_id: this.newRecord.artist } })

        .then(response => {
          this.records.push(response.data)
          this.newRecord = ''
        })
        .catch(error => this.setError(error, 'Error creating record'))
    },
    removeRecord (record) {
      this.$http.secured.delete(`/api/v1/records/${record.id}`)
        .then(response => {
          this.records.splice(this.records.indexOf(record), 1)
        })
        .catch(error => this.setError(error, 'Error deleting record'))
    },
    editRecord (record) {
      this.editedRecord = record
    },
    updateRecord (record) {
      this.editedRecord = ''
      this.$http.secured.patch(`/api/v1/records/${record.id}`, { record: { title: record.title, year: record.year, artist_id: record.artist } })
        .catch(error => this.setError(error, 'Error updating record'))
    }
  }
}
</script>
