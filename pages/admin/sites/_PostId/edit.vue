<template>
  <div style="margin-buttom: 300px;">
     
    <main style="top: 50px; position: relative;">
         <ValidationObserver ref="observer" v-slot="{ passes }">
     <form @submit.prevent>
         <InputWithValidation
            rules="required" 
            label="WEBサイト名"
            vid="title"
            v-model="title"
            />
        <InputWithValidation
            rules="required" 
            label="価格"
            vid="price"
            v-model="price"
        />
        <InputWithValidation
            rules="required" 
            label="難易度"
            vid="difficultyLevel"
            v-model="difficultyLevel"
        />
        <InputWithValidation
            rules="required" 
            label="URL"
            vid="url"
            v-model="url"
        />
        <InputWithValidation
            rules="required" 
            label="environment"
            vid="environment"
            v-model="environment"
        />
        <InputWithValidation
            rules="required|max:200" 
            label="description"
            type="textarea"
            vid="description"
            v-model="description"
        />
         
        <b-field class="file is-primary" :class="{'has-name': !!file}">
        <b-upload v-model="file" class="file-label">
            <span class="file-cta">
                <b-icon class="file-icon" icon="upload"></b-icon>
                <span class="file-label">Click to upload</span>
            </span>
            <span class="file-name" v-if="file">
               
            </span>
        </b-upload>
    </b-field>
    <b-button type="is-success" @click="PatchSites()" outlined>学習サイト情報追加</b-button>
        <!-- <button type="submit" @click="PatchSites()">学習サイト情報追加</button> -->
    </form>
    </ValidationObserver>
    <b-field>
             <!-- :data="filteredTags" -->
            <b-taginput
            @remove="RemoveTag"
                v-model="tags"
               :data="filteredTags"
                autocomplete
                placeholder="学べる技術"
                :allow-new="true"
                field="tag_name"
                icon="label"
                 type="is-dark"
                 @add="CheckExistTags"   
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <b-button type="is-success" @click="updateSiteTags()" outlined>学習サイトタグ追加</b-button>

         <pre style="max-height: 400px"><b>スキルタグ配列チェックTags:</b>{{ tags }}</pre>
    </main>
  </div>
</template>

<script>
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import InputWithValidation from "~/components/Form/InputWithValidation.vue";
import BSelectWithValidation from "~/components/Form/BSelectWithValidation.vue";


 export default {
    components: {
        ValidationObserver,
        ValidationProvider ,
        InputWithValidation,
        BSelectWithValidation
    },
    data() {
      return {
         site : "",
         title : "",
          description : "",
          price : "",
          difficultyLevel : "",
          url : "",
          environment : "",
          file : null,
          DeleteTags : [],
            tags: [],
            skills: null,
            skill_tags : [],
            CategoryIdList : [], 
            filteredTags : [],
            data:[],
            IsUserSkills : false,
            allowNew: false,
            openOnFocus: false,
    }
    },
    created () {
        this.fetchSite()
        this.FetchCategories()
        this.FetchSiteTags()
    },
  methods: {
      fetchSite () {
        const id = this.$route.params.PostId
        console.log(id)
        console.log("###")
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
        this.$axios.$get(`/api/v1/admin/sites/${id}/edit`)
        .then(res => {
        console.log(res.data)
        console.log(res)
        this.title = res.data.title
        this.description = res.data.description
        this.price = res.data.price
        this.difficultyLevel = res.data.difficulty_level
        this.url = res.data.url
        this.environment = res.data.environment
        this.file = res.image
        })
    .catch ( error => {
      if (error.response.status == "404") {
          console.log("書籍が見つかりません")
          this.$buefy.toast.open({
            duration: 5000,
            message: '書籍が見つかりません',
            type: 'is-danger'
          })
      }
    })
    },
    FetchCategories () {
        this.$axios.$get('/api/v1/fetch_categories')
        .then(res => {
            this.filteredTags = res.tag
            this.data = res.tag       
        })
        .catch ( error => {
            if (error.response.status == "401") {
                console.log("tokenが無効です")
                this.$buefy.toast.open({
                    duration: 5000,
                    message: 'サーバー内でも問題が発生しました',
                    type: 'is-danger'
                 })
             }
        })
    },
    PatchSites() {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            var formData = new FormData();
            formData.append('site[file]', this.file );
            formData.append('site[title]', this.title );
            formData.append('site[description]', this.description );
            formData.append('site[price]', this.price );
            formData.append('site[difficulty_level]', this.difficultyLevel );
            formData.append('site[url]', this.url );
            formData.append('site[environment]', this.environment );

            const id = this.$route.params.PostId
            this.$axios.$patch(`/api/v1/admin/sites/${id}`,formData,{ 
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
        
           
        },
        getFilteredTags(text) {
        this.filteredTags = this.data.filter((option) => {
            return option.tag_name
            .toString()
            .toLowerCase()
            .indexOf(text.toLowerCase()) >= 0
        })
      },

      updateSiteTags () {
        const site_id = this.$route.params.PostId
        this.$axios.$post('/api/v1/admin/site_categories',{ 
        site_category : {
            skill_arrays : this.tags,
            site_id: site_id
        }
        })
        .then(response => {
            this.$buefy.toast.open({
                duration: 5000,
                message: '編集が完了しました',
                type: 'is-success'
            })
            console.log(response)
        })
        .catch ( error => {
            if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                console.log(error)
                // this.error = "Tokenが無効です"
                this.$buefy.toast.open({
                    duration: 5000,
                    message: 'サーバー内で問題が発生しました',
                    type: 'is-danger'
                })
             }
        })
      },
      FetchSiteTags () {
          const site_id = this.$route.params.PostId
            this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get(`/api/v1/admin/site_categories/${site_id}/edit`)
            .then(res => {
            // if (res.data.length === 0) {
            //     this.IsUserSkills = false
                
            // } else {
            //     this.IsUserSkills = true
            // }
             console.log(this.IsUserSkills)
             this.tags = res.data
            //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
             console.log()
            })
            .catch ( error => {
                if (error.response.status == "401") {
                    console.log("tokenが無効です")
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内でも問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
        },
     
    
  }
 }
 
</script>