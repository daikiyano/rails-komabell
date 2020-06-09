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
                :open-on-focus="openOnFocus"
                field="tag_name"
                icon="label"
                 type="is-dark"
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <pre style="max-height: 400px"><b>スキルタグ配列チェックTags:</b>{{ tags }}</pre>
        保有スキル配列チェック{{skill_tags}}
        <div v-if="this.tags.length > 0">
          <div v-for="(tag, index) in this.tags" :key="index">
            

            <!-- {{tag.tag_name}} -->
                          <img :src="tag.icon_url" alt="">

            <b-field :label="tag.tag_name">
              <b-slider type="is-success" :min="0" :max="4" :tooltip="false" :aria-label="tag.tag_name" @input="ChangeSkillTagsArrays(index,tag.id,tag.tag_name,$event)">
                 <b-slider-tick :value="0">0</b-slider-tick>
                <b-slider-tick :value="1">25</b-slider-tick>
                <b-slider-tick :value="2">50</b-slider-tick>
                <b-slider-tick :value="3">75</b-slider-tick>
                <b-slider-tick :value="4">100</b-slider-tick>
              </b-slider>
            </b-field>
          </div>
        </div>
        <button class="button" type="is-dark" @click="UpdateMySkills">マイスキルを追加する</button>
   

   
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
     
          tags: [],
          skills: null,
          skill_tags : [],
        filteredTags : [],
        data:[],
        allowNew: false,
        openOnFocus: false,
    }
  },
  created() {
       this.FetchCategories()
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
        var skill_tags = this.skill_tags
            for (let [index,skill_tag] of skill_tags.entries() ){
          
            if (e.id === skill_tag[0]) {
              this.skill_tags.splice(index,1)
            }
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
                // console.log(res.tag)
                // for (var i = 0;  i < res.tag.length;  i++) {

                // //     // this.filteredTags.push([res.tag[i]["id"],res.tag[i]["tag_name"]])
                // //     //  this.filteredTags[res.tag[i]["id"]] = res.tag[i]["tag_name"];
                //   this.filteredTags.push([this.filteredTags["id"] = res.tag[i]["id"],this.filteredTags["tag_name"] = res.tag[i]["tag_name"]])
                //   this.data.push([this.filteredTags["id"] = res.tag[i]["id"],this.filteredTags["tag_name"] = res.tag[i]["tag_name"]])

                    // this.filteredTags["id"] = res.tag[i]["id"];
                    // this.filteredTags["tag_name"] = res.tag[i]["tag_name"];
                //     this.data.id = res.tag[i]["id"];
                //     this.data.id = res.tag[i]["tag_name"];
                  
                //     // this.data[res.tag[i]["id"]] = res.tag[i]["tag_name"];
                // }   
                // console.log(this.filteredTags)
                
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
              // console.log(option)
                return option.tag_name
                .toString()
                .toLowerCase()
                .indexOf(text.toLowerCase()) >= 0
            })
      },
      UpdateMySkills() {
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
      }

   }
}

</script>
