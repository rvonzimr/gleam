import services/telegram/api
import services/telegram/models

// Loosely following Bot updates?
pub type Message {
  ChatMemberUpdate(models.ChatMemberUpdated)
  NewMessage(models.Message)
}

type Poller {
  Poller(service: api.Service, offset: Int, listen_for: List(String))
}

fn handle_message() {
  todo
}
