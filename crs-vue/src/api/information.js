import http from '@/utils/request'

export default {
  async getInformationListAll(params) {
    console.log(params + "这是前端information/listAll传过来的数据")
    return  http.get("/api/information/listAll", params);
  },
  async InformationById(params) {
    console.log(params + "这是前端information传过来的数据")
    return http.get("/api/information/InformationById", params)
  },
}
