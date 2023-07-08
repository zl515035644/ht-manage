import http from '@/utils/request'

export default {
  async gethujiListAll(params) {
    return http.get("/api/huji/listAll", params);
  },
}
