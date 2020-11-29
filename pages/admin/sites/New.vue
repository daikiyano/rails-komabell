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
         <pre style="max-height: 400px"><b>スキルタグ配列チェックTags:</b>{{ tags }}</pre>
         
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
        </b-upload><br>
        
    </b-field>
    {{skill_tags}}
    
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
        file : "",
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
      this.FetchCategories()
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
                } 
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
            console.log(this.tags)
        this.$axios.$post('/api/v1/admin/site_categories',{ 
        site_category : {
            skill_arrays : this.tags
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
    getFilteredTags(text) {
        this.filteredTags = this.data.filter((option) => {
            return option.tag_name
            .toString()
            .toLowerCase()
            .indexOf(text.toLowerCase()) >= 0
        })
      },
    ChangeSkillTagsArrays(index,skill_id,tag,e) {
      var skill_tags = this.skill_tags;
      console.log("#######")
        if (skill_tags.length === 0) {
          console.log("length")
          this.skill_tags.push([skill_id,tag,e])
        } else {
          // 同じskill_idが存在していたらslice更新、存在しない場合はpush追加
          console.log(this.skill_tags)
          const result = skill_tags.some((skill_tag) => skill_tag[0] === skill_id);
        if (result) {
          const value = [skill_id, tag,e]
          skill_tags.splice(index,1,value)
        } else {
          skill_tags.push([skill_id,tag,e])
        }
        }
     },
     CreateMySkills() {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
        this.$axios.$post('/api/v1/admin/site_categories',{ 
            user_skill_category : {
                skill_arrays : this.tag
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
    
  }
 }
</script>
