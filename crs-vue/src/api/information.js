import http from '@/utils/request'

export default {
  async getInformationListAll(params) {
    return  http.get("/api/information/listAll", params);
  },
  async InformationById(params) {
    return http.get("/api/information/InformationById", params)
  },
}
