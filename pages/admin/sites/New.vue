<template>
  <div>
    <main style="top: 50px; position: relative;">
     <form @submit.prevent>
         <b-field label="WEBサイト名">
            <b-input v-model="title"></b-input>
        </b-field>
        <b-field label="価格">
            <b-input v-model="price"></b-input>
        </b-field>
        <b-field label="難易度">
            <b-input v-model="difficultyLevel"></b-input>
        </b-field>
        <b-field label="url">
            <b-input v-model="url"></b-input>
        </b-field>
        <b-field label="environment">
            <b-input v-model="environment"></b-input>
        </b-field>
        <b-field label="概要">
            <b-input maxlength="200" type="textarea" v-model="description"></b-input>
        </b-field>
        <b-field class="file is-primary" :class="{'has-name': !!file}">
        <b-upload v-model="file" class="file-label">
            <span class="file-cta">
                <b-icon class="file-icon" icon="upload"></b-icon>
                <span class="file-label">Click to upload</span>
            </span>
            <span class="file-name" v-if="file">
                {{ file.name }}
            </span>
        </b-upload>
    </b-field>
        <button type="submit" @click="PostSites()">学習サイト情報追加</button>
    </form>
    </main>
  </div>
</template>

<script>


 export default {
     middleware: 'admin',
    components: {

    },
    data() {
      return {
          title : "",
          description : "",
          price : "",
          difficultyLevel : "",
          url : "",
          environment : "",
          file : ""
    }
    },
    created () {
      
    },
  methods: {
    PostSites() {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            var formData = new FormData();
            formData.append('site[file]', this.file );
            formData.append('site[title]', this.title );
            formData.append('site[description]', this.description );
            formData.append('site[price]', this.price );
            formData.append('site[difficulty_level]', this.difficultyLevel );
            formData.append('site[url]', this.url );
            formData.append('site[environment]', this.environment );

            if(this.file) {
            this.$axios.$post('/api/v1/admin/sites',formData,{ 
                headers: {
                    'Content-Type': 'multipart/form-data'
                } ,
                // site : {
                //     title : this.title,
                //     description : this.description,
                //     price : this.price,
                //     difficultyLevel : this.difficultyLevel,
                //     url : this.url,
                //     environment : this.environment,
                // }
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '画像アップロードが完了しました',
                    type: 'is-success'
                })
                
            })
            .catch ( error => {
                if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                    console.log("tokenが無効です")
                        // this.error = "Tokenが無効です"
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内で問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
            }
        }
    
  }
 }
</script>
