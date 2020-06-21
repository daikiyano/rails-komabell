<template>
<div>

        <MyPageTab :activeTab="activeTab" />
        <b-field>
             <!-- :data="filteredTags" -->
            <b-taginput
            @remove="RemoveTag"
                v-model="tags"
               :data="filteredTags"
                autocomplete
                placeholder="保有している技術を追加してください"
                :allow-new="true"
                field="tag_name"
                icon="label"
                 type="is-dark"
                 @add="CheckExistTags"   
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <pre style="max-height: 400px"><b>スキルタグ配列チェックTags:</b>{{ tags }}</pre>
        {{DeleteTags}}

        保有スキル配列チェック{{skill_tags}}
        <div v-if="this.tags.length > 0">
          <div v-for="(tag, index) in this.tags" :key="index">
            
            <!-- {{tag.tag_name}} -->
                          <img :src="tag.icon_url" alt="">

            <b-field :label="tag.tag_name">
              <b-slider type="is-success" 
                    :min="0" :max="100" 
                    :value="tag.skill" 
                    :tooltip="false" 
                    :aria-label="tag.tag_name" 
                    @input="ChangeSkillTagsArrays(index,tag.id,tag.tag_name,$event)"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                    >   
                <b-slider-tick :value="0">0</b-slider-tick>
                <b-slider-tick :value="25">25</b-slider-tick>
                <b-slider-tick :value="50">50</b-slider-tick>
                <b-slider-tick :value="75">75</b-slider-tick>
                <b-slider-tick :value="100">100</b-slider-tick>
              </b-slider>
            </b-field>
          </div>
        </div>
        <button class="button" type="is-dark" @click="IsUserSkills ? UpdateMySkills() : CreateMySkills()">マイスキルを追加する</button>

   
</div>
</template>
<script>
import MyPageTab from '~/components/users/MyPageTab.vue'

export default {
    components: {
        MyPageTab
    },
    data() {
    return {
      activeTab: 2,
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
  created() {
       this.FetchCategories()
       this.FetchUserSkills()
       
    },
  mounted() {
    
  },
    watch: {
        filteredTags: function(val) {
            if (val.length === 0){
                this.filteredTags = this.data
                
            }
        },        
      //   form: {
      //   handler: function (val, oldVal) {
      //       this.count += 1
      //       if (this.count > 0) {

      //       }
      //   },
      //   deep: true
      // }
    },
   methods: {
    //  タグが取り除かれたとき
     RemoveTag (e) {
         console.log("removeTag")
         console.log(e)
        //  this.DeleteTags.push(e)
        //  const result = this.DeleteTags.some((DeleteTag) => skill_tag[0] === skill_id);
        var skill_tags = this.skill_tags
            for (let [index,skill_tag] of skill_tags.entries() ){
          
                if (e.id === skill_tag[0]) {
                this.skill_tags.splice(index,1)
                }
            }
     },
     //  スキルタグ追加後、に追加したタグがダブって追加されしまうのを防ぐためのCheckTag
     CheckExistTags() {
         console.log("CheckTag")
        //  追加されたタグのインデックス番号取得
         const LastIndex = this.tags.length - 1
        //  追加されたタグを除く既存のタグを取得
         const OldTags = this.tags.slice(0,-1)
         const NewTags = this.tags
         //  既存タグリストに追加されたタグが存在していたらTrue。削除
         const result = OldTags.some((OldTag) => OldTag.tag_name === NewTags[LastIndex].tag_name);
         if (result) {
             console.log(result)
          NewTags.splice(LastIndex,1)
        }  
     },
    //  スキルグラフが追加、または変更されたとき
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
        FetchUserSkills () {
            this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get('/api/v1/myskill/user_skill_categories/index')
            .then(res => {
            if (res.data.length === 0) {
                this.IsUserSkills = false
                
            } else {
                this.IsUserSkills = true
            }
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
     getFilteredTags(text) {
            
            this.filteredTags = this.data.filter((option) => {
                return option.tag_name
                .toString()
                .toLowerCase()
                .indexOf(text.toLowerCase()) >= 0
            })
      },
      CreateMySkills() {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
            this.$axios.$post('/api/v1/myskill/user_skill_categories',{ 
                user_skill_category : {
                    skill_arrays : this.skill_tags
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
      UpdateMySkills () {
        console.log("UpdateMySkills")
        console.log(this.skill_tags)
        
        for (let skill_tag of this.skill_tags){
                console.log(skill_tag[0])
                this.CategoryIdList.push(skill_tag[0])
            }
            console.log(this.CategoryIdList)

         this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
            this.$axios.$patch('/api/v1/myskill/user_skill_categories',{ 
                
                user_skill_category : {
                    skill_arrays : this.skill_tags,
                    category_list : this.CategoryIdList
                }
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '編集が完了しました',
                    type: 'is-success'
                })
                 console.log(response)
                 this.CategoryIdList = []
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
     
    

   },
  
}

</script>
