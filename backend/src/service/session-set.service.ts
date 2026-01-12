import { UpdateSessionSetDto } from "../dto/session-set.dto";
import { SessionSetCreationAttributes } from "../models/sessionSet";
import { SessionSetRepository } from "../repository/session-set.repository";

export class SessionSetService {
    private repo = new SessionSetRepository();

    async list() {
        return this.repo.list();
    }

    async getOne(id: string) {
        return this.repo.getOne(id);
    }

    async create(data: SessionSetCreationAttributes) {
        return this.repo.create(data);
    }

    async update(data: UpdateSessionSetDto) {
        return this.repo.update(data);
    }

    async delete(id: string) {
        return this.repo.delete(id);
    }
}